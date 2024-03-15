import UIKit
/**
 * Represents the UIKit adaptor for `ArkInputHandling`, `GameRenderer`
 *
 * Example usage;
 * ```
 * let shape = ArkUi.Shape()
 * shape.drawCircle(0,0,25).fill("#ffffff").stroke("#ffffff")
 * ArkUi.Image()
 * .frame()
 * .render()
 *```
 * Split ArkUiAdaptor into input and output handlers.
 *
 * InputHandlers should deal with things like event listeners.
 * Come up with a Delegate that event listeners will need to conform to in order to execute.
 * `.addEventListener(.buttonTap, ButtonTapDelegate)`
 * `.addEventListener(.pan, PanDelegate)`
 *
 * Can probably use MVVM-C to render.
 * Let the ECS components and rendering parts of the system be observable (or observable by the game renderer)
 */
class ArkUi {
}
