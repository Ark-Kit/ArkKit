import CoreGraphics

struct RectRenderableComponent: ShapeRenderableComponent {
    let width: Double
    let height: Double
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var opacity: Double = 1.0
    var isUserInteractionEnabled = false
    var renderLayer: RenderLayer = .canvas
    var onTapDelegate: TapDelegate?
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?
    private(set) var labelInfo: ShapeLabelInfo?

    init(width: Double, height: Double,
         fillInfo: ShapeFillInfo? = nil,
         strokeInfo: ShapeStrokeInfo? = nil,
         labelInfo: ShapeLabelInfo? = nil) {
        self.width = width
        self.height = height
        self.fillInfo = fillInfo
        self.strokeInfo = strokeInfo
        self.labelInfo = labelInfo
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?,
                labelInfo: ShapeLabelInfo?) -> RectRenderableComponent {
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
