import CoreGraphics

struct ButtonCanvasComponent: AbstractTappable, CanvasComponent {
    let width: Double
    let height: Double
    var center: CGPoint
    var rotation: Double
    let areValuesEqual: AreValuesEqualDelegate

    var onTapDelegate: TapDelegate?

    init(width: Double, height: Double, center: CGPoint, rotation: Double = 0.0,
         areValuesEqual: @escaping (ButtonCanvasComponent, ButtonCanvasComponent) -> Bool = { _, _ in false }) {
        self.width = width
        self.height = height
        self.center = center
        self.rotation = rotation
        self.areValuesEqual = areValuesEqual
    }

    func modify(onTapDelegate: TapDelegate?) -> ButtonCanvasComponent {
        var updated = ButtonCanvasComponent(width: width, height: height, center: center,
                                            rotation: rotation,
                                            areValuesEqual: areValuesEqual)
        updated.onTapDelegate = onTapDelegate
        return updated
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> ButtonCanvasComponent {
        updater.update(self)
    }
}
