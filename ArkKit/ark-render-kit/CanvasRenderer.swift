/**
 * The `CanvasRenderer` implements the rendering logic to each `RenderableComponent`
 * of entities in the game state.
 *
 * It should be implemented by the `ArkUiAdapter` or other `UiAdapters` to map different renderable
 * components.
 *
 * Devs can also **extend** the `CanvasRenderer` if they have custom `canvas elements` to render.
 */
protocol CanvasRenderer {
    func render(circle: Any)
    /**
     * An example implementation for GameRenderer:
     * ```
     *  func visit(_ gameObject: CircularGameObject) {
     *      let circle = CircleUi(radius: gameObject.radius,
     *                            center: CGPoint(gameObject.center))
     *      circle.render(into: superview)
     *
     *  }
     * ```
     */
    func render(rect: Any)
    func render(image: Any)
    func render(button: Any)
}
