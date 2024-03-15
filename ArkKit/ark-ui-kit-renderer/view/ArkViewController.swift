import UIKit

/**
 * `ArkViewController` is the main page that the developers
 */
class ArkViewController: UIViewController {
}

extension ArkViewController: GameStateRenderer {
    func render(canvas: Canvas) {
        // implementation must involve:
        // [OPTIMISED]
        // 1. removing any invalid ui that is no longer in the renderableGameState
        // 2. updating remaining ui values to the values in renderableGameState
        // OR
        // [NOT-OPTIMISED]
        // 1. removing the entire previous view
        // 2. re-rendering all components within the renderableGameState
    }
}
