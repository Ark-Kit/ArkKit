import CoreGraphics

struct RectCanvasComponent: ShapeCanvasComponent {
    let width: Double
    let height: Double
    let center: CGPoint

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(width: Double, height: Double, center: CGPoint) {
        self.width = width
        self.height = height
        self.center = center
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> RectCanvasComponent {
        var copy = RectCanvasComponent(width: width, height: height, center: center)
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func render(using renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
