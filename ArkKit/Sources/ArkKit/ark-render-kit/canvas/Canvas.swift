/**
 * The `Canvas` contains information about all `RenderableComponents`
 * in the `GameState` of the `Ark` game instance at any point in time (frame), and should be exposed
 * by the `GameState`.
 *
 * It is generally used as part of the `MVVM` pattern, where the `Model` is the `GameState`,
 * and the `ViewModel` holds the renderable subset of the `GameState`; the `View` observes
 * the `Canvas` held in the ViewModel.
 *
 * Example usage in MVVM:
 * ```swift
 * class ViewModel {
 *    var canvas: Canvas {
 *          didSet {
 *              gameStateRenderer?.render(canvas)
 *          }
 *    }
 * }
 * ```
 */
protocol Canvas {
    typealias RenderableComponentType = ObjectIdentifier
    typealias CanvasElements = [EntityID: [RenderableComponentType: any RenderableComponent]]
    var canvasElements: CanvasElements { get }
    mutating func addEntityRenderableToCanvas(entityId: EntityID,
                                              componentType: RenderableComponentType,
                                              renderableComponent: any RenderableComponent)
}
