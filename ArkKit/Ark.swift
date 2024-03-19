// TODO: remove dependency to UIKit
import UIKit
/**
 * `Ark` describes a **running instance** of the game.
 *
 * `Ark.start(blueprint)` starts the game from `deltaTime = 0` based on the
 *  information and data in the `ArkBlueprint` provided.
 */
class Ark {
    // TODO: remove UIKit dependency
    // The `rootView` should compose:
    // 1. handle rendering of the game -> RenderingKit
    // 2. handle game loop updates -> LoopKit
    let rootView: UINavigationController
    let eventManager = ArkEventManager()
    let ecsManager = ArkECS()
    let gameScene: AbstractArkGameScene // Ideas for naming this please, maybe physics scene but it sounds weird

    init(rootView: UINavigationController) {
        self.rootView = rootView
        // TODO: Change to take in the game size instead of the root nav controller
        // Currently the simulator is defined to use the Sprite Kit simulator
        // In the future, we can look at exposing this in the blueprint
        self.gameScene = SKGameScene(size: rootView.view.frame.size)
    }

    func start(blueprint: ArkBlueprint) {
        setup(blueprint.rules)
        setup(blueprint.ecsSetupFunctions)

        // TODO: initialize animation system
        let animationSystem = ArkAnimationSystem()
        ecsManager.addSystem(animationSystem)

        // Initialize game with specified physics engine that conforms to `ark-physics-facade`
        let physicsSystem = ArkPhysicsSystem(gameScene: gameScene, eventManager: eventManager)

        // Initializee game with rootView, and eventManager
        let gameCoordinator = ArkGameCoordinator(rootView: rootView,
                                                 eventManager: eventManager,
                                                 arkECS: ecsManager)
        gameCoordinator.start()
    }

    private func setup(_ rules: [Rule]) {
        // subscribe all rules to the eventManager
        for rule in rules {
            eventManager.subscribe(to: rule.event) { [weak self] (event: any ArkEvent) -> Void in
                guard let arkInstance = self else {
                    return
                }
                rule.action.execute(event,
                                    eventContext: arkInstance.eventManager,
                                    ecsContext: arkInstance.ecsManager)
            }
        }
    }

    private func setup(_ ecsSetupFunctions: [ECSSetupFunction]) {
        for ecsSetupFunction in ecsSetupFunctions {
            ecsManager.setup(ecsSetupFunction)
        }
    }
}
