import CoreGraphics

struct ButtonCanvasComponent: CanvasComponent {
    let width: Double
    let height: Double
    let center: CGPoint
    func accept(_ renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
