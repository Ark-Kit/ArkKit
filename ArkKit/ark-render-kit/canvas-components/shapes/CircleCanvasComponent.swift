import CoreGraphics

struct CircleCanvasComponent: ShapeCanvasComponent {
    let radius: Double
    let center: CGPoint

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(radius: Double, center: CGPoint) {
        self.radius = radius
        self.center = center
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> CircleCanvasComponent {
        var copy = CircleCanvasComponent(radius: radius, center: center)
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func render(using renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
