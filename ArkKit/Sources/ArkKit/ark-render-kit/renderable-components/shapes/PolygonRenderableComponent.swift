import CoreGraphics

public struct PolygonRenderableComponent: ShapeRenderableComponent {
    public let points: [CGPoint]
    public let frame: CGRect
    public var center: CGPoint = .zero
    public var rotation: Double = 0.0
    public var zPosition: Double = 0.0
    public var opacity: Double = 1.0
    public var renderLayer: RenderLayer = .canvas
    public var isUserInteractionEnabled = false
    public var shouldRerenderDelegate: ShouldRerenderDelegate?
    public var onTapDelegate: TapDelegate?

    public var fillInfo: ShapeFillInfo?
    public var strokeInfo: ShapeStrokeInfo?
    public var labelInfo: ShapeLabelInfo?

    public init(points: [CGPoint], frame: CGRect,
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

    public func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?,
                labelInfo: ShapeLabelInfo?) -> PolygonRenderableComponent {
        var copy = self

        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        copy.labelInfo = labelInfo

        return copy
    }

    public func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}
