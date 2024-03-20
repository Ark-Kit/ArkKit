import CoreGraphics

struct PolygonCanvasComponent: ShapeCanvasComponent {
    let points: [CGPoint]
    let frame: CGRect
    let center: CGPoint
    let rotation: Double
    let areValuesEqual: AreValuesEqualDelegate

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(points: [CGPoint], frame: CGRect,
         rotation: Double = 0.0,
         areValuesEqual: @escaping (PolygonCanvasComponent, PolygonCanvasComponent) -> Bool = { _, _ in false }) {
        self.points = points
        self.frame = frame
        self.center = CGPoint(x: frame.midX, y: frame.midY)
        self.rotation = rotation
        self.areValuesEqual = areValuesEqual
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> PolygonCanvasComponent {
        var copy = PolygonCanvasComponent(points: points, frame: frame, rotation: rotation,
                                          areValuesEqual: areValuesEqual)
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> PolygonCanvasComponent {
        updater.update(self)
    }
}
