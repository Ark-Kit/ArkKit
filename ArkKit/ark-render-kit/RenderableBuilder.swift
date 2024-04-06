/**
 * The `RenderableBuilder` implements the rendering logic of each `Renderable`.
 *
 * It should be implemented by the `ArkUiKit-Library` or other `Ui-Libraries` to render various renderables.
 *
 * Devs can also **extend** the `RenderableBuilder` if they have custom renderable components to render.
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
    func build(_ container: CameraContainerRenderableComponent) -> any Renderable<Container>
}

extension RenderableBuilder {
    func getColor(_ abstractColor: AbstractColor?) -> ConcreteColor {
        colorMapping[abstractColor ?? .default] ?? defaultColor
    }
}
