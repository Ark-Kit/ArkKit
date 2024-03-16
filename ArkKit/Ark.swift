// TODO: remove dependency to UIKit
import UIKit
/**
 * `Ark` describes the blueprint of a game. Devs should only use `Ark` to create their games
 * by defining the rules, events, and inputs.
 *
 * `Ark.start()`: returns the running instance of the game at a particular timeframe, `deltaTime` or `dt`.
 */
class Ark {
    var eventManager: ArkEventManager

    // TODO: remove UIKit dependency
    // The `rootView` should compose:
    // 1. handle rendering of the game -> RenderingKit
    // 2. handle game loop updates -> LoopKit
    var rootView: UINavigationController

    init(eventManager: ArkEventManager, rootView: UINavigationController) {
        self.eventManager = eventManager
        self.rootView = rootView
    }

    func start() {
        // initialise game with rootView, and eventManager
        let gameCoordinator = ArkGameCoordinator(rootView: rootView,
                                                 eventManager: eventManager)
        gameCoordinator.start()
    }

    // == DEFINE THE GAME VIA THE FOLLOWING METHODS == //
    func rules(on event: Any, then action: Any) {
        // TODO: implement and update types once Event and Action types defined.
    }
    func input(inputType: Any, anchor: Any, callback: Any) {
        // TODO: implement
    }
}
