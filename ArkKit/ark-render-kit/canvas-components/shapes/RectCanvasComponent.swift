import CoreGraphics

struct RectCanvasComponent: ShapeCanvasComponent {
    let width: Double
    let height: Double
    let center: CGPoint
    let areValuesEqual: AreValuesEqualDelegate

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(width: Double, height: Double, center: CGPoint,
         areValuesEqual: @escaping (RectCanvasComponent, RectCanvasComponent) -> Bool = { _, _ in false }) {
        self.width = width
        self.height = height
        self.center = center
        self.areValuesEqual = areValuesEqual
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> RectCanvasComponent {
        var copy = RectCanvasComponent(width: width, height: height, center: center, areValuesEqual: areValuesEqual)
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }
}
