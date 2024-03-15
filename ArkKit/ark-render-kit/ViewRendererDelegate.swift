/**
 * The View Renderer Delegate is implemented by the `ArkUiAdapter` to host its own
 * `UIKitViewController`.
 *
 * The Delegate is its own protocol so that other ui-adaptors like `SwiftUi` will be possible
 * for future extension.
 */
protocol ViewRendererDelegate: AnyObject {
    func render(from renderableGameState: RenderableGameState)
}
