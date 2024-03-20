import CoreGraphics

struct CircleCanvasComponent: ShapeCanvasComponent {
    let radius: Double
    let center: CGPoint
    let areValuesEqual: AreValuesEqualDelegate

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(radius: Double, center: CGPoint,
         areValuesEqual: @escaping (CircleCanvasComponent, CircleCanvasComponent) -> Bool = { _, _ in false }) {
        self.radius = radius
        self.center = center
        self.areValuesEqual = areValuesEqual
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> CircleCanvasComponent {
        var copy = CircleCanvasComponent(radius: radius, center: center, areValuesEqual: areValuesEqual)
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> CircleCanvasComponent {
        updater.update(self)
    }
}
