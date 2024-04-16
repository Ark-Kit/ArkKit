import Foundation

protocol ArkSetUpStrategy<View, ExternalResources> {
    associatedtype View
    associatedtype ExternalResources: ArkExternalResources
    var ark: Ark<View, ExternalResources>? { get set }

    func setUp()
}

extension ArkSetUpStrategy {
    func setupDefaultListeners() {
        guard let ark = ark else {
            return
        }

        let arkState = ark.arkState

        arkState.eventManager.subscribe(to: ScreenResizeEvent.self) { event in
            guard let resizeEvent = event as? ScreenResizeEvent else {
                return
            }
            ark.displayContext.updateScreenSize(resizeEvent.eventData.newSize)
        }

        arkState.eventManager.subscribe(to: PauseGameLoopEvent.self) { event in
            guard let _ = event as? PauseGameLoopEvent else {
                return
            }
            ark.gameLoop?.pauseLoop()
        }

        arkState.eventManager.subscribe(to: ResumeGameLoopEvent.self) { event in
            guard let _ = event as? ResumeGameLoopEvent else {
                return
            }
            ark.gameLoop?.resumeLoop()

        }

        arkState.eventManager.subscribe(to: TerminateGameLoopEvent.self) { event in
            guard let _ = event as? TerminateGameLoopEvent else {
                return
            }
            ark.gameLoop?.shutDown()
        }
    }

    func setup(_ rules: [any Rule], with actionContext: ArkActionContext<ExternalResources>? = nil) {
        guard let ark = ark else {
            return
        }

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
            ark.arkState.eventManager.subscribe(to: rule.trigger.eventType) { event in
                let areConditionsSatisfied = rule.conditions
                    .allSatisfy { $0(ark.actionContext.ecs) }
                if areConditionsSatisfied {
                    event.executeAction(rule.action, context: actionContext ?? ark.actionContext)
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
            guard let action = rule.action as? any Action<ArkTimeFacade, ExternalResources> else {
                continue
            }
            let system = ArkUpdateSystem(action: action, context: ark.actionContext)
            ark.arkState.arkECS.addSystem(system, schedule: .update, isUnique: false)
        }
    }

    func setup(_ stateSetupFunctions: [ArkStateSetupDelegate], with setUpContext: ArkSetupContext? = nil) {
        guard let ark = ark else {
            return
        }

        for stateSetupFunction in stateSetupFunctions {
            ark.arkState.setup(stateSetupFunction, with: setUpContext ?? ark.setupContext)
        }
    }

    func setup(_ soundMapping: [ExternalResources.AudioEnum: any Sound]?) {
        guard let soundMapping = soundMapping,
              let ark = ark else {
            return
        }

        ark.audioContext.load(soundMapping)
    }

    func setupDefaultEntities() {
        ark?.arkState.arkECS.createEntity(with: [StopWatchComponent(name: ArkTimeSystem.ARK_WORLD_TIME)])
    }

    func setupDefaultSystems(_ blueprint: ArkBlueprint<ExternalResources>) {
        guard let ark = ark else {
            return
        }

        let (worldWidth, worldHeight) = getWorldSize(blueprint)

        let simulator = SKSimulator(size: CGSize(width: worldWidth, height: worldHeight))
        ark.gameLoop = simulator
        let physicsUpdateSystem = ArkPhysicsUpdateSystem(simulator: simulator,
                                                         eventManager: ark.arkState.eventManager,
                                                         arkECS: ark.arkState.arkECS)
        let animationSystem = ArkAnimationSystem()
        let canvasSystem = ArkCanvasSystem()
        let timeSystem = ArkTimeSystem()
        let cameraSystem = ArkCameraSystem()
        let entityRemovalSystem = ArkEntityRemovalSystem()
        entityRemovalSystem.arkPhysicsRemovalDelegate = physicsUpdateSystem
        ark.arkState.arkECS.addSystem(timeSystem)
        ark.arkState.arkECS.addSystem(physicsUpdateSystem)
        ark.arkState.arkECS.addSystem(animationSystem)
        ark.arkState.arkECS.addSystem(canvasSystem)
        ark.arkState.arkECS.addSystem(cameraSystem)
        ark.arkState.arkECS.addSystem(entityRemovalSystem)

        // inject dependency into game loop
        let physicsSyncSystem = ArkPhysicsSyncSystem(simulator: simulator,
                                                     eventManager: ark.arkState.eventManager,
                                                     arkECS: ark.arkState.arkECS)
        ark.arkState.arkECS.addSystem(physicsSyncSystem)
        simulator.physicsScene?.sceneContactUpdateDelegate = physicsSyncSystem
        simulator.physicsScene?.sceneUpdateLoopDelegate = physicsSyncSystem
        ark.gameLoop?.updatePhysicsSceneDelegate = physicsSyncSystem
    }

    func setupMultiplayerGameLoop() {
        guard let ark = ark,
              let networkPlayableInfo = ark.blueprint.networkPlayableInfo,
              networkPlayableInfo.role == .participant else {
            return
        }
        let gameLoop = ArkMultiplayerGameLoop()
        ark.gameLoop = gameLoop
    }

    func getWorldSize(_ blueprint: ArkBlueprint<ExternalResources>) -> (width: Double, height: Double) {
        guard let ark = ark,
              let worldEntity = ark.arkState.arkECS.getEntities(with: [WorldComponent.self]).first,
              let worldComponent = ark.arkState.arkECS
              .getComponent(ofType: WorldComponent.self, for: worldEntity)
        else {
            return (blueprint.frameWidth, blueprint.frameHeight)
        }
        return (worldComponent.width, worldComponent.height)
    }
}
