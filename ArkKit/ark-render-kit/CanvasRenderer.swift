/**
 * The `CanvasRenderer` implements the rendering logic of each `Renderable`.
 *
 * It should be implemented by the `ArkUiAdapter` or other `UiAdapters` to render various renderables.
 *
 * Devs can also **extend** the `CanvasRenderer` if they have custom canvas elements to render.
 */
protocol CanvasRenderer {
    associatedtype ConcreteColor
    var colorMapping: [AbstractColor: ConcreteColor] { get }
    var defaultColor: ConcreteColor { get }

    func render(_ circle: CircleRenderableComponent) -> any Renderable
    func render(_ rect: RectRenderableComponent) -> any Renderable
    func render(_ polygon: PolygonRenderableComponent) -> any Renderable
    func render(_ image: BitmapImageRenderableComponent) -> any Renderable
    func render(_ button: ButtonRenderableComponent) -> any Renderable
    func render(_ joystick: JoystickRenderableComponent) -> any Renderable

    func upsertToView<T: Renderable>(_ renderable: T, at renderLayer: RenderLayer)
}

extension CanvasRenderer {
    func getColor(_ abstractColor: AbstractColor?) -> ConcreteColor {
        colorMapping[abstractColor ?? .default] ?? defaultColor
    }
}
