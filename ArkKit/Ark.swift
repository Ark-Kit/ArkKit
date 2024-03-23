import Foundation
/**
 * `Ark` describes a **running instance** of the game.
 *
 * `Ark.start(blueprint)` starts the game from `deltaTime = 0` based on the
 *  information and data in the `ArkBlueprint` provided.
 *
 * User of the `Ark` instance should ensure that the `arkInstance` is **binded** (strongly referenced), otherwise events
 * relying on the `arkInstance` will not emit.
 */
class Ark {
    let rootView: any AbstractParentView
    let arkState: ArkState
    var gameLoop: AbstractArkSimulator?
    
    var sceneUpdateDelegate : ArkSceneUpdateDelegate?

    init(rootView: any AbstractParentView) {
        self.rootView = rootView
        let eventManager = ArkEventManager()
        let ecsManager = ArkECS()
        self.arkState = ArkState(eventManager: eventManager, arkECS: ecsManager)
    }

    func start(blueprint: ArkBlueprint) {
        setup(blueprint.setupFunctions)
        setup(blueprint.rules)
        setupDefaultEntities()
        setupDefaultSystems(blueprint)

        // Initializee game with rootView, and eventManager
        let gameCoordinator = ArkGameCoordinator(rootView: rootView,
                                                 arkState: arkState,
                                                 canvasFrame: CGRect(x: 0, y: 0,
                                                                     width: blueprint.frameWidth,
                                                                     height: blueprint.frameHeight),
                                                 gameLoop: self.gameLoop!)
        gameCoordinator.arkSceneUpdateDelegate = self
        gameCoordinator.start()
    }

    private func setup(_ rules: [Rule]) {
        // subscribe all rules to the eventManager
        for rule in rules {
            arkState.eventManager.subscribe(to: rule.event) { [weak self] (event: any ArkEvent) -> Void in
                guard let arkInstance = self else {
                    return
                }
                rule.action.execute(event,
                                    eventContext: arkInstance.arkState.eventManager,
                                    ecsContext: arkInstance.arkState.arkECS)
            }
        }
    }

    private func setup(_ stateSetupFunctions: [ArkStateSetupFunction]) {
        for stateSetupFunction in stateSetupFunctions {
            arkState.setup(stateSetupFunction)
        }
    }

    private func setupDefaultEntities() {
        arkState.arkECS.createEntity(with: [StopWatchComponent(name: ArkTimeSystem.ARK_WORLD_TIME)])
    }

    private func setupDefaultSystems(_ blueprint: ArkBlueprint) {
        let (worldWidth, worldHeight) = getWorldSize(blueprint)
        let simulator = SKSimulator(size: CGSize(width: worldWidth, height: worldHeight))
        self.gameLoop = simulator
        let physicsSystem = ArkPhysicsSystem(simulator: simulator, eventManager: arkState.eventManager, arkECS: arkState.arkECS)
        sceneUpdateDelegate = physicsSystem
        let animationSystem = ArkAnimationSystem()
        let canvasSystem = ArkCanvasSystem()
        let timeSystem = ArkTimeSystem()
        arkState.arkECS.addSystem(timeSystem)
        arkState.arkECS.addSystem(physicsSystem)
        arkState.arkECS.addSystem(animationSystem)
        arkState.arkECS.addSystem(canvasSystem)
    }

    private func getWorldSize(_ blueprint: ArkBlueprint) -> (width: Double, height: Double) {
        guard let worldEntity = arkState.arkECS.getEntities(with: [WorldComponent.self]).first,
              let worldComponent = arkState.arkECS
            .getComponent(ofType: WorldComponent.self, for: worldEntity) else {
            return (blueprint.frameWidth, blueprint.frameHeight)
        }
        return (worldComponent.width, worldComponent.height)
    }
}

extension Ark: ArkSceneUpdateDelegate {
    func didContactBegin(between entityA: Entity, and entityB: Entity) {
        sceneUpdateDelegate?.didContactBegin(between: entityA, and: entityB)
    }
    
    func didContactEnd(between entityA: Entity, and entityB: Entity) {
        sceneUpdateDelegate?.didContactEnd(between: entityA, and: entityB)
    }
    
    func didFinishUpdate(_ deltaTime: TimeInterval) {
        sceneUpdateDelegate?.didFinishUpdate(deltaTime)
    }
}
