import CoreGraphics

struct JoystickCanvasComponent: AbstractPannable, CanvasComponent {
    let center: CGPoint
    let radius: Double
    let rotation: Double
    let areValuesEqual: AreValuesEqualDelegate

    var onPanStartDelegate: PanDelegate?
    var onPanChangeDelegate: PanDelegate?
    var onPanEndDelegate: PanDelegate?

    init(center: CGPoint, radius: Double,
         rotation: Double = 0.0,
         areValuesEqual: @escaping (JoystickCanvasComponent, JoystickCanvasComponent) -> Bool = { _, _ in false }) {
        self.center = center
        self.radius = radius
        self.rotation = rotation
        self.areValuesEqual = areValuesEqual
    }

    func modify(
        onPanStartDelegate: PanDelegate?,
        onPanChangeDelegate: PanDelegate?,
        onPanEndDelegate: PanDelegate?
    ) -> JoystickCanvasComponent {
        var updated = JoystickCanvasComponent(center: center, radius: radius, rotation: rotation,
                                              areValuesEqual: areValuesEqual)
        updated.onPanStartDelegate = onPanStartDelegate
        updated.onPanChangeDelegate = onPanChangeDelegate
        updated.onPanEndDelegate = onPanEndDelegate
        return updated
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> JoystickCanvasComponent {
        updater.update(self)
    }
}
