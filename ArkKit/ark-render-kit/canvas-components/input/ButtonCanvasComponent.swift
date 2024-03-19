import CoreGraphics

struct ButtonCanvasComponent: AbstractTappable, CanvasComponent {
    let width: Double
    let height: Double
    let center: CGPoint

    var onTapDelegate: TapDelegate?

    init(width: Double, height: Double, center: CGPoint) {
        self.width = width
        self.height = height
        self.center = center
    }

    func modify(onTapDelegate: TapDelegate?) -> ButtonCanvasComponent {
        var updated = ButtonCanvasComponent(width: width, height: height, center: center)
        updated.onTapDelegate = onTapDelegate
        return updated
    }

    func render(using renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
