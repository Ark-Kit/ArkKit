import CoreGraphics

struct CircleCanvasComponent: ShapeCanvasComponent {
    private(set) var radius: Double
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var isUserInteractionEnabled = false
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(radius: Double) {
        self.radius = radius
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
