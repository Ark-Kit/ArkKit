/**
 * The `CanvasRenderer` implements the rendering logic of each `Renderable`.
 *
 * It should be implemented by the `ArkUiAdapter` or other `UiAdapters` to render various renderables.
 *
 * Devs can also **extend** the `CanvasRenderer` if they have custom canvas elements to render.
 */
protocol CanvasRenderer<Container> {
    associatedtype ConcreteColor
    associatedtype Container

    var canvasView: Container { get }
    var rootView: Container { get }
    var colorMapping: [AbstractColor: ConcreteColor] { get }
    var defaultColor: ConcreteColor { get }

    func render(_ circle: CircleRenderableComponent) -> any Renderable<Container>
    func render(_ rect: RectRenderableComponent) -> any Renderable<Container>
    func render(_ polygon: PolygonRenderableComponent) -> any Renderable<Container>
    func render(_ image: BitmapImageRenderableComponent) -> any Renderable<Container>
    func render(_ button: ButtonRenderableComponent) -> any Renderable<Container>
    func render(_ joystick: JoystickRenderableComponent) -> any Renderable<Container>

    func upsertToView(_ renderable: any Renderable<Container>, at renderLayer: RenderLayer)
}

extension CanvasRenderer {
    func getColor(_ abstractColor: AbstractColor?) -> ConcreteColor {
        colorMapping[abstractColor ?? .default] ?? defaultColor
    }
}
