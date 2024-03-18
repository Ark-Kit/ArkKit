import CoreGraphics

struct RectCanvasComponent: CanvasComponent {
    let width: Double
    let height: Double
    let center: CGPoint
    func render(using renderer: CanvasRenderer) {
        renderer.render(self)
    }
}
