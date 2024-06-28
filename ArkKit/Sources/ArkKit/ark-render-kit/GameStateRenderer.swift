import Foundation

/**
 * `GameStateRenderer` is implemented by the `ArkUiAdapter` to host its own
 * `UIKitViewController`.
 *
 * The GameStateRenderer delegate is its own protocol so that adapters can be created for other UI implementations
 * like `SwiftUI`.
 */
protocol GameStateRenderer<View>: AnyObject {
    associatedtype View
    func render(_ canvas: Canvas, with canvasContext: any CanvasContext<View>)
}
