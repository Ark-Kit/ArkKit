import CoreGraphics

struct PolygonRenderableComponent: ShapeRenderableComponent {
    let points: [CGPoint]
    let frame: CGRect
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = false
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(points: [CGPoint], frame: CGRect, rotation: Double = 0.0) {
        self.points = points
        self.frame = frame
        self.center = CGPoint(x: frame.midX, y: frame.midY)
        self.rotation = rotation
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> PolygonRenderableComponent {
        var copy = self

        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo

        return copy
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> PolygonRenderableComponent {
        updater.update(self)
    }
}
