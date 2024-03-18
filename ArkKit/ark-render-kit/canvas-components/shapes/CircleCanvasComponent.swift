import CoreGraphics

struct CircleCanvasComponent: CanvasComponent {
    let radius: Double
    let center: CGPoint
    func render(using renderer: CanvasRenderer) {
        renderer.render(self)
    }
}
