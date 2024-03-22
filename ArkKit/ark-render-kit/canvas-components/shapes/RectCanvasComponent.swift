import CoreGraphics

struct RectCanvasComponent: ShapeCanvasComponent {
    let width: Double
    let height: Double
    var center: CGPoint
    var rotation: Double
    var zPosition: Double = 0.0
    let areValuesEqual: AreValuesEqualDelegate

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(width: Double, height: Double, center: CGPoint = .zero, rotation: Double = 0.0,
         areValuesEqual: @escaping (RectCanvasComponent, RectCanvasComponent) -> Bool = { _, _ in false }) {
        self.width = width
        self.height = height
        self.center = center
        self.rotation = rotation
        self.areValuesEqual = areValuesEqual
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> RectCanvasComponent {
        var copy = RectCanvasComponent(width: width, height: height, center: center, rotation: rotation,
                                       areValuesEqual: areValuesEqual)
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> RectCanvasComponent {
        updater.update(self)
    }
}
