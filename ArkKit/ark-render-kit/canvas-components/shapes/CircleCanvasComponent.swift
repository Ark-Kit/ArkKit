import CoreGraphics

struct CircleCanvasComponent: ShapeCanvasComponent {
    private(set) var radius: Double
    var center: CGPoint
    var rotation: Double
    private(set) var areValuesEqual: AreValuesEqualDelegate

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(radius: Double, rotation: Double = 0.0,
         areValuesEqual: @escaping (CircleCanvasComponent, CircleCanvasComponent) -> Bool = { _, _ in false }) {
        self.radius = radius
        self.center = .zero
        self.rotation = rotation
        self.areValuesEqual = areValuesEqual
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> CircleCanvasComponent {
        var copy = self
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
