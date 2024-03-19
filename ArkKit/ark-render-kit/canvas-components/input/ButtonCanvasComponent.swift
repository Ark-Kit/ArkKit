import CoreGraphics

struct ButtonCanvasComponent: AbstractTappable, CanvasComponent {
    let width: Double
    let height: Double
    let center: CGPoint
    let areValuesEqual: AreValuesEqualDelegate

    var onTapDelegate: TapDelegate?

    init(width: Double, height: Double, center: CGPoint,
         areValuesEqual: @escaping (ButtonCanvasComponent, ButtonCanvasComponent) -> Bool = { _, _ in false }) {
        self.width = width
        self.height = height
        self.center = center
        self.areValuesEqual = areValuesEqual
    }

    func modify(onTapDelegate: TapDelegate?) -> ButtonCanvasComponent {
        var updated = ButtonCanvasComponent(width: width, height: height, center: center,
                                            areValuesEqual: areValuesEqual)
        updated.onTapDelegate = onTapDelegate
        return updated
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }
}
