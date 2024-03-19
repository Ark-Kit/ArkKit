import CoreGraphics

struct PolygonCanvasComponent: ShapeCanvasComponent {
    let points: [CGPoint]
    let frame: CGRect

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(points: [CGPoint], frame: CGRect) {
        self.points = points
        self.frame = frame
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> PolygonCanvasComponent {
        var copy = PolygonCanvasComponent(points: points, frame: frame)
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func render(using renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
