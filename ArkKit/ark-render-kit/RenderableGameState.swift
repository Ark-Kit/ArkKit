/**
 * The `RenderableGameState` contains information about all `RenderableComponents`
 * in the `GameState` of the `Ark` game instance at any point in time (frame), and should be exposed
 * by the `GameState`.
 *
 * It is generally used as part of the `MVVM` pattern, where the `Model` is the `GameState`,
 * and the `ViewModel` holds the renderable subset of the `GameState`; the `View` observes
 * the `RenderableGameState` held in the ViewModel.
 *
 * Example usage in MVVM:
 * ```swift
 * class ViewModel {
 *    var renderableGameState: RenderableGameState {
 *          didSet {
 *              gameStateRenderer?.render(renderableGameState)
 *          }
 *    }
 * }
 * ```
 */
protocol RenderableGameState: Canvas {

}
