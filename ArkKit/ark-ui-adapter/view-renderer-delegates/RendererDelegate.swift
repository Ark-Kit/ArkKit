protocol RendererDelegate: AnyObject {
    /**
     * General implementation of the RendererDelegate:
     * ```
     * render(renderableGameState) {
     *     renderableGameState.accept(gameStateRendererVisitor)
     * }
     * ```
     * ArkUiAdaptor implements the `render` function where it reads the `gameState` and renders
     * assigned objects based on the `renderedGameState` with a default `GameStateRendererVisitor`.
     *
     * Devs can customise the rendering with their own `GameStateRendererVisitor`.
     */
    func render(from renderableGameState: RenderableGameState)
}

/**
 * The Visitor will implement the rendering logic
 */
protocol GameStateRendererVisitor {
    func visit()
    /**
     * An example implementation for GameRenderer:
     * ```
     *  func visit(_ gameObject: CircularGameObject) {
     *      let circle = CircleUi(radius: gameObject.radius,
     *                            center: CGPoint(gameObject.center))
     *      circle.render(into: superview)
     *  }
     * ```
     */
}

protocol RenderableGameState {
    func accept(visitor: GameStateRendererVisitor)
}
