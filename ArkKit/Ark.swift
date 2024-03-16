// TODO: remove dependency to UIKit
import UIKit
/**
 * `Ark` describes the blueprint of a game. Devs should only use `Ark` to create their games
 * by defining the rules, events, and inputs.
 *
 * `Ark.start()`: returns the running instance of the game at a particular timeframe, `deltaTime` or `dt`.
 */
class Ark {
    // TODO: remove UIKit dependency
    // The `rootView` should compose:
    // 1. handle rendering of the game -> RenderingKit
    // 2. handle game loop updates -> LoopKit
    let rootView: UINavigationController
    var eventContext = ArkEventManager()
    let ecsContext = ArkECS()

    init(rootView: UINavigationController) {
        self.rootView = rootView
    }

    func start(blueprint: ArkBlueprint) {
        // subscribe all rules to the eventManager
        for rule in blueprint.rules {
            eventContext.subscribe(to: rule.event) { [weak self] (event: any ArkEvent) -> Void in
                guard let arkInstance = self else {
                    return
                }
                rule.action.execute(event,
                                    eventContext: arkInstance.eventContext,
                                    ecsContext: arkInstance.ecsContext)
            }
        }
        // initialise game with rootView, and eventManager
        let gameCoordinator = ArkGameCoordinator(rootView: rootView,
                                                 eventManager: self.eventContext,
                                                 arkECS: self.ecsContext)
        gameCoordinator.start()
    }
}
