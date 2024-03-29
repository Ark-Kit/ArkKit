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
class Ark {
    let rootView: any AbstractRootView
    let arkState: ArkState
    var gameLoop: GameLoop?

    let blueprint: ArkBlueprint
    let audioContext: AudioContext

    var displayContext: ArkDisplayContext {
        ArkDisplayContext(
            canvasSize: CGSize(width: blueprint.frameWidth,
                               height: blueprint.frameHeight),
            screenSize: rootView.size)
    }

    var actionContext: ArkActionContext {
        ArkActionContext(ecs: arkState.arkECS,
                         events: arkState.eventManager,
                         display: displayContext,
                         audio: audioContext)
    }

    var canvasContext: ArkCanvasContext {
        ArkCanvasContext(ecs: arkState.arkECS,
                         canvasFrame: CGRect(x: 0, y: 0,
                                             width: blueprint.frameWidth,
                                             height: blueprint.frameHeight))
    }

    init(rootView: any AbstractRootView, blueprint: ArkBlueprint) {
        self.rootView = rootView
        self.blueprint = blueprint
        let eventManager = ArkEventManager()
        let ecsManager = ArkECS()
        self.arkState = ArkState(eventManager: eventManager, arkECS: ecsManager)
        self.audioContext = ArkAudioPlayer()
    }

    func start() {
        setup(blueprint.setupFunctions)
        setup(blueprint.rules)
        setupDefaultEntities()
        setupDefaultSystems(blueprint)

        guard let gameLoop = self.gameLoop else {
            return
        }

        // Initializee game with rootView, and passing in contexts (state)
        let gameCoordinator = ArkGameCoordinator(rootView: rootView,
                                                 arkState: arkState,
                                                 canvasContext: canvasContext,
                                                 gameLoop: gameLoop)
        gameCoordinator.start()
    }

    private func setup(_ rules: [any Rule]) {
        // subscribe all rules to the eventManager
        for rule in rules {
            arkState.eventManager.subscribe(to: rule.event) { event in
                event.executeAction(rule.action, context: self.actionContext)
            }
        }
    }

    private func setup(_ stateSetupFunctions: [ArkStateSetupDelegate]) {
        for stateSetupFunction in stateSetupFunctions {
            arkState.setup(stateSetupFunction, displayContext: displayContext)
        }
    }

    private func setupDefaultEntities() {
        arkState.arkECS.createEntity(with: [StopWatchComponent(name: ArkTimeSystem.ARK_WORLD_TIME)])
    }

    private func setupDefaultSystems(_ blueprint: ArkBlueprint) {
        let (worldWidth, worldHeight) = getWorldSize(blueprint)

        let simulator = SKSimulator(size: CGSize(width: worldWidth, height: worldHeight))
        self.gameLoop = simulator
        let physicsSystem = ArkPhysicsSystem(simulator: simulator,
                                             eventManager: arkState.eventManager,
                                             arkECS: arkState.arkECS)
        let animationSystem = ArkAnimationSystem()
        let canvasSystem = ArkCanvasSystem()
        let timeSystem = ArkTimeSystem()
        arkState.arkECS.addSystem(timeSystem)
        arkState.arkECS.addSystem(physicsSystem)
        arkState.arkECS.addSystem(animationSystem)
        arkState.arkECS.addSystem(canvasSystem)

        // inject dependency into game loop
        simulator.physicsScene?.sceneContactUpdateDelegate = physicsSystem
        simulator.physicsScene?.sceneUpdateLoopDelegate = physicsSystem
        self.gameLoop?.updatePhysicsSceneDelegate = physicsSystem
    }

    private func getWorldSize(_ blueprint: ArkBlueprint) -> (width: Double, height: Double) {
        guard let worldEntity = arkState.arkECS.getEntities(with: [WorldComponent.self]).first,
              let worldComponent = arkState.arkECS
              .getComponent(ofType: WorldComponent.self, for: worldEntity)
        else {
            return (blueprint.frameWidth, blueprint.frameHeight)
        }
        return (worldComponent.width, worldComponent.height)
    }
}

extension ArkEvent {
    /// A workaround to prevent weird behavior when trying to execute
    /// `action.execute(event, context: context)`
    func executeAction(_ action: some Action, context: ArkActionContext) {
        guard let castedAction = action as? any Action<Self> else {
            return
        }

        castedAction.execute(self, context: context)
    }
}
