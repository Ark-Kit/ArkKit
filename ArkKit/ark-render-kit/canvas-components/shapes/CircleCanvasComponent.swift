import CoreGraphics

struct CircleCanvasComponent: CanvasComponent {
    let radius: Double
    let center: CGPoint
    func accept(_ renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
