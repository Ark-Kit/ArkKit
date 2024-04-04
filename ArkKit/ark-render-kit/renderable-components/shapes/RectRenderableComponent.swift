import CoreGraphics

struct RectRenderableComponent: ShapeRenderableComponent {
    let width: Double
    let height: Double
    var center: CGPoint
    var rotation: Double
    var zPosition: Double = 0.0
    var isUserInteractionEnabled = false
    var renderLayer: RenderLayer = .canvas
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(width: Double, height: Double, center: CGPoint = .zero, rotation: Double = 0.0) {
        self.width = width
        self.height = height
        self.center = center
        self.rotation = rotation
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> RectRenderableComponent {
        var copy = self

        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo

        return copy
    }

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}
