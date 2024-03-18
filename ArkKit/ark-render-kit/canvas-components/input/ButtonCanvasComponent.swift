import CoreGraphics

struct ButtonCanvasComponent: CanvasComponent {
    let width: Double
    let height: Double
    let center: CGPoint
    func render(using renderer: CanvasRenderer) {
        renderer.render(self)
    }
}
