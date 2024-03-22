import CoreGraphics

struct CircleRenderableComponent: ShapeRenderableComponent {
    private(set) var radius: Double
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var isUserInteractionEnabled = false
    var renderLayer: RenderLayer = .canvas
    private(set) var areValuesEqual: AreValuesEqualDelegate

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(radius: Double,
         areValuesEqual: @escaping (CircleRenderableComponent, CircleRenderableComponent) -> Bool = { _, _ in false }) {
        self.radius = radius
        self.areValuesEqual = areValuesEqual
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> CircleRenderableComponent {
        var copy = self
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> CircleRenderableComponent {
        updater.update(self)
    }
}
