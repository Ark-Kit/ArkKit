import CoreGraphics

struct RectCanvasComponent: CanvasComponent {
    let width: Double
    let height: Double
    let center: CGPoint
    func accept(_ renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
