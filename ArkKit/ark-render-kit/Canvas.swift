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
    // For container components
//    var canvasElements: [any RenderableComponent] { get }

    typealias RenderableComponentType = ObjectIdentifier

    // OBSOLETE
    // TODO: change -- a canvas is now a list of container components
    var canvasEntityToRenderableMapping: [EntityID: [RenderableComponentType: any RenderableComponent]] { get }
}

// TODO: MEGA CANVAS
// V1
// Canvas
// /              |  \
// ChildCanvas

// V2
// Canvas

// V3
                    // Canvas
// Screen_ContainerComponent (share same w and h) -- rendered last at highest z |
// Camera_ContainerComponents (
