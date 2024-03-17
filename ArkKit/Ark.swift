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

    init(rootView: UINavigationController) {
        self.rootView = rootView
    }

    func start(blueprint: ArkBlueprint) {
        // subscribe all rules to the eventManager
        for rule in blueprint.rules {
            eventManager.subscribe(to: rule.event) { [weak self] (event: any ArkEvent) -> Void in
                guard let arkInstance = self else {
                    return
                }
                rule.action.execute(event,
                                    eventContext: arkInstance.eventManager,
                                    ecsContext: arkInstance.ecsManager)
            }
        }
        
        // TODO: initialize animation system
        
        // Initializee game with rootView, and eventManager
        let gameCoordinator = ArkGameCoordinator(rootView: rootView,
                                                 eventManager: self.eventManager,
                                                 arkECS: self.ecsManager)
        gameCoordinator.start()
    }
}
