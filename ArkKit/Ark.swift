// TODO: remove dependency to UIKit
import UIKit
/**
 * `Ark` describes the blueprint of a game. Devs should only use `Ark` to create their games by defining the rules, events, and inputs.
 *
 * `Ark.start()`: returns the running instance of the game at a particular timeframe, `deltaTime` or `dt`.
 */
class Ark {
    var eventManager: Any // TODO: update when EventManager is built

    // TODO: remove UIKit dependency
    // The `rootView` should compose:
    // 1. handle rendering of the game -> RenderingKit
    // 2. handle game loop updates -> LoopKit
    var rootView: UINavigationController

    init(eventManager: Any, rootView: UINavigationController) {
        self.eventManager = eventManager
        self.rootView = rootView
    }

    func start() {
        // push the view into the root view controller
        // inject dependencies
        /**
         * Example implementation:
         *```
         * let model = ArkEcs(eventManger: EventMangaer)
         * let uiKitView = ArkUiKitView()
         * rootView.push(uiKitView) // -> effect: (ui will render && display loop will run)
         *```
         */
    }

    // == DEFINE THE GAME VIA THE FOLLOWING METHODS == //
    func rules(on event: Any, then action: Any) {
        // TODO: implement and update types once Event and Action types defined.
    }
    func input(inputType: Any, anchor: Any, callback: Any) {
        // TODO: implement
    }
}
