import CoreGraphics

public struct RectRenderableComponent: ShapeRenderableComponent {
    public let width: Double
    public let height: Double
    public var center: CGPoint = .zero
    public var rotation: Double = 0.0
    public var zPosition: Double = 0.0
    public var opacity: Double = 1.0
    public var isUserInteractionEnabled = false
    public var renderLayer: RenderLayer = .canvas
    public var onTapDelegate: TapDelegate?
    public var shouldRerenderDelegate: ShouldRerenderDelegate?

    public var fillInfo: ShapeFillInfo?
    public var strokeInfo: ShapeStrokeInfo?
    public var labelInfo: ShapeLabelInfo?

    public init(width: Double, height: Double,
         fillInfo: ShapeFillInfo? = nil,
         strokeInfo: ShapeStrokeInfo? = nil,
         labelInfo: ShapeLabelInfo? = nil) {
        self.width = width
        self.height = height
        self.fillInfo = fillInfo
        self.strokeInfo = strokeInfo
        self.labelInfo = labelInfo
    }

    public func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?,
                labelInfo: ShapeLabelInfo?) -> RectRenderableComponent {
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
