import CoreGraphics

struct CircleRenderableComponent: ShapeRenderableComponent {
    private(set) var radius: Double
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = false
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?
    private(set) var labelInfo: ShapeLabelInfo?

    init(radius: Double) {
        self.radius = radius
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?, labelInfo: ShapeLabelInfo?) -> CircleRenderableComponent {
        var copy = self
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        copy.labelInfo = labelInfo
        return copy
    }

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}
