import CoreGraphics

struct JoystickCanvasComponent: AbstractPannable, CanvasComponent {
    let center: CGPoint
    let radius: Double

    var onPanStartDelegate: PanDelegate?
    var onPanChangeDelegate: PanDelegate?
    var onPanEndDelegate: PanDelegate?

    init(center: CGPoint, radius: Double) {
        self.center = center
        self.radius = radius
    }

    func modify(
        onPanStartDelegate: PanDelegate?,
        onPanChangeDelegate: PanDelegate?,
        onPanEndDelegate: PanDelegate?
    ) -> JoystickCanvasComponent {
        var updated = JoystickCanvasComponent(center: center, radius: radius)
        updated.onPanStartDelegate = onPanStartDelegate
        updated.onPanChangeDelegate = onPanChangeDelegate
        updated.onPanEndDelegate = onPanEndDelegate
        return updated
    }

    func render(using renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
