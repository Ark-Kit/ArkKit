import Foundation

/**
 * `Ark` describes the game as is **loaded**.
 *
 * It loads the various contexts from the  `ArkBlueprint` provided and the `GameLoop`.
 * `Ark` requires a `rootView: AbstractRootView` to render the game.
 *
 * `Ark.start()` starts a loaded version of the game by injecting the game context dependencies.
 *
 * User of the `Ark` instance should ensure that the `arkInstance` is **binded** (strongly referenced), otherwise events
 * relying on the `arkInstance` will not emit.
 */
class Ark<View, AudioEnum: ArkAudioEnum>: ArkProtocol {
    let rootView: any AbstractRootView<View>
    var arkState: ArkState
    var gameLoop: GameLoop?

    let blueprint: ArkBlueprint<AudioEnum>
    let audioContext: any AudioContext<AudioEnum>

    var displayContext: ArkDisplayContext {
        ArkDisplayContext(
            canvasSize: CGSize(width: blueprint.frameWidth,
                               height: blueprint.frameHeight),
            screenSize: rootView.size)
    }

    var actionContext: ArkActionContext<AudioEnum> {
        ArkActionContext(ecs: arkState.arkECS,
                         events: arkState.eventManager,
                         display: displayContext,
                         audio: audioContext)
    }

    var canvasRenderableBuilder: (any RenderableBuilder<View>)?

    init(rootView: any AbstractRootView<View>,
         blueprint: ArkBlueprint<AudioEnum>,
         canvasRenderableBuilder: (any RenderableBuilder<View>)? = nil) {
        self.rootView = rootView
        self.blueprint = blueprint
        let eventManager = ArkEventManager()
        let ecsManager = ArkECS()
        self.arkState = ArkState(eventManager: eventManager, arkECS: ecsManager)
        self.audioContext = ArkAudioContext()
        self.canvasRenderableBuilder = canvasRenderableBuilder
    }

    func start() {
        setupDefaultEntities()
        setupDefaultSystems(blueprint)
        setup(blueprint.setupFunctions)
        setup(blueprint.rules)
        setup(blueprint.soundMapping)
        alignCamera()

        guard let gameLoop = self.gameLoop else {
            return
        }
        // Initialize game with rootView, and passing in contexts (state)
        let gameCoordinator = ArkGameCoordinator(rootView: rootView,
                                                 arkState: arkState,
                                                 displayContext: displayContext,
                                                 gameLoop: gameLoop,
                                                 canvasRenderer: canvasRenderableBuilder)
        gameCoordinator.start()
    }

    private func setup(_ rules: [any Rule]) {
        // filter for event-based rules only
        let eventRules: [any Rule<RuleEventType>] = rules.filter { rule in
            rule.trigger is RuleEventType
        }.map { rule in
            guard let eventRule = rule as? any Rule<RuleEventType> else {
                fatalError("[Ark.setup(rules)] map failed: Unexpected type in array")
            }
            return eventRule
        }
        // sort the rules by priority before adding to eventContext
        let sortedRules = eventRules.sorted(by: { x, y in
            if x.trigger == y.trigger {
                return x.action.priority < y.action.priority
            }
            return true
        })
        // subscribe all rules to the eventManager
        for rule in sortedRules {
            arkState.eventManager.subscribe(to: rule.trigger.eventType) { event in
                let areConditionsSatisfied = rule.conditions
                    .allSatisfy { $0(self.actionContext.ecs) }
                if areConditionsSatisfied {
                    event.executeAction(rule.action, context: self.actionContext)
                }
            }
        }

        // filter for time-based rules only
        let timeRules: [any Rule<RuleTrigger>] = rules.filter { rule in
            guard let trigger = rule.trigger as? RuleTrigger else {
                return false
            }
            return trigger == RuleTrigger.updateSystem
        }.map { rule in
            guard let timeRule = rule as? any Rule<RuleTrigger> else {
                fatalError("[Ark.setup(rules)] map failed: Unexpected type in array")
            }
            return timeRule
        }

        for rule in timeRules {
            guard let action = rule.action as? any Action<TimeInterval, AudioEnum> else {
                continue
            }
            let system = ArkUpdateSystem(action: action, context: self.actionContext)
            arkState.arkECS.addSystem(system, schedule: .update, isUnique: false)
        }
    }

    private func setup(_ stateSetupFunctions: [ArkStateSetupDelegate]) {
        for stateSetupFunction in stateSetupFunctions {
            arkState.setup(stateSetupFunction, displayContext: displayContext)
        }
    }

    private func setup(_ soundMapping: [AudioEnum: any Sound]?) {
        guard let soundMapping = soundMapping else {
            return
        }

        audioContext.load(soundMapping)
    }

    private func setupDefaultEntities() {
        arkState.arkECS.createEntity(with: [StopWatchComponent(name: ArkTimeSystem.ARK_WORLD_TIME)])
    }

    private func setupDefaultSystems(_ blueprint: ArkBlueprint<AudioEnum>) {
        let (worldWidth, worldHeight) = getWorldSize(blueprint)

        let simulator = SKSimulator(size: CGSize(width: worldWidth, height: worldHeight))
        self.gameLoop = simulator
        let physicsSystem = ArkPhysicsSystem(simulator: simulator,
                                             eventManager: arkState.eventManager,
                                             arkECS: arkState.arkECS)
        let animationSystem = ArkAnimationSystem()
        let canvasSystem = ArkCanvasSystem()
        let timeSystem = ArkTimeSystem()
        let cameraSystem = ArkCameraSystem()
        arkState.arkECS.addSystem(timeSystem)
        arkState.arkECS.addSystem(physicsSystem)
        arkState.arkECS.addSystem(animationSystem)
        arkState.arkECS.addSystem(canvasSystem)
        arkState.arkECS.addSystem(cameraSystem)

        // inject dependency into game loop
        simulator.physicsScene?.sceneContactUpdateDelegate = physicsSystem
        simulator.physicsScene?.sceneUpdateLoopDelegate = physicsSystem
        self.gameLoop?.updatePhysicsSceneDelegate = physicsSystem
    }

    private func getWorldSize(_ blueprint: ArkBlueprint<AudioEnum>) -> (width: Double, height: Double) {
        guard let worldEntity = arkState.arkECS.getEntities(with: [WorldComponent.self]).first,
              let worldComponent = arkState.arkECS
              .getComponent(ofType: WorldComponent.self, for: worldEntity)
        else {
            return (blueprint.frameWidth, blueprint.frameHeight)
        }
        return (worldComponent.width, worldComponent.height)
    }

    private func alignCamera() {
        let cameraEntities = arkState.arkECS.getEntities(with: [PlacedCameraComponent.self])
        if !cameraEntities.isEmpty {
            return
        }
        arkState.arkECS.createEntity(with: [PlacedCameraComponent(
            camera: Camera(
                canvasPosition: CGPoint(
                    x: displayContext.canvasSize.width / 2,
                    y: displayContext.canvasSize.height / 2
                ),
                zoom: 1.0
            ),
            screenPosition: CGPoint(
                x: displayContext.screenSize.width / 2,
                y: displayContext.screenSize.height / 2
            ),
            size: displayContext.screenSize)
        ])
    }
}

extension ArkEvent {
    /// A workaround to prevent weird behavior when trying to execute
    /// `action.execute(event, context: context)`
    func executeAction<AudioEnum: ArkAudioEnum>(_ action: some Action, context: ArkActionContext<AudioEnum>) {
        guard let castedAction = action as? any Action<Self, AudioEnum> else {
            return
        }

        castedAction.execute(self, context: context)
    }
}
