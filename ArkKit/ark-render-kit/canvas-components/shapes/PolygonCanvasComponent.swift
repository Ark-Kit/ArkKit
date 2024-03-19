import CoreGraphics

struct PolygonCanvasComponent: ShapeCanvasComponent {
    let points: [CGPoint]
    let frame: CGRect
    let areValuesEqual: AreValuesEqualDelegate

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(points: [CGPoint], frame: CGRect,
         areValuesEqual: @escaping (PolygonCanvasComponent, PolygonCanvasComponent) -> Bool = { _, _ in false }) {
        self.points = points
        self.frame = frame
        self.areValuesEqual = areValuesEqual
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> PolygonCanvasComponent {
        var copy = PolygonCanvasComponent(points: points, frame: frame, areValuesEqual: areValuesEqual)
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }
}
