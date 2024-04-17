import CoreGraphics

struct PolygonRenderableComponent: ShapeRenderableComponent {
    let points: [CGPoint]
    let frame: CGRect
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var opacity: Double = 1.0
    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = false
    var shouldRerenderDelegate: ShouldRerenderDelegate?
    var onTapDelegate: TapDelegate?

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?
    private(set) var labelInfo: ShapeLabelInfo?

    init(points: [CGPoint], frame: CGRect,
         fillInfo: ShapeFillInfo? = nil,
         strokeInfo: ShapeStrokeInfo? = nil,
         labelInfo: ShapeLabelInfo? = nil) {
        self.points = points
        self.frame = frame
        self.center = CGPoint(x: frame.midX, y: frame.midY)
        self.fillInfo = fillInfo
        self.strokeInfo = strokeInfo
        self.labelInfo = labelInfo
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?,
                labelInfo: ShapeLabelInfo?) -> PolygonRenderableComponent {
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
