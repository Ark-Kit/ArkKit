/**
 * The `CanvasRenderer` implements the rendering logic of each `Renderable`.
 *
 * It should be implemented by the `ArkUiAdapter` or other `UiAdapters` to render various renderables.
 *
 * Devs can also **extend** the `CanvasRenderer` if they have custom canvas elements to render.
 */
protocol RenderableBuilder<Container> {
    associatedtype ConcreteColor
    associatedtype Container

    var colorMapping: [AbstractColor: ConcreteColor] { get }
    var defaultColor: ConcreteColor { get }

    func build(_ circle: CircleRenderableComponent) -> any Renderable<Container>
    func build(_ rect: RectRenderableComponent) -> any Renderable<Container>
    func build(_ polygon: PolygonRenderableComponent) -> any Renderable<Container>
    func build(_ image: BitmapImageRenderableComponent) -> any Renderable<Container>
    func build(_ button: ButtonRenderableComponent) -> any Renderable<Container>
    func build(_ joystick: JoystickRenderableComponent) -> any Renderable<Container>
    func build(_ container: ContainerRenderableComponent) -> any Renderable<Container>
}

extension RenderableBuilder {
    func getColor(_ abstractColor: AbstractColor?) -> ConcreteColor {
        colorMapping[abstractColor ?? .default] ?? defaultColor
    }
}
