import CoreGraphics

struct JoystickCanvasComponent: CanvasComponent {
    let center: CGPoint
    let radius: Double
    func render(using renderer: CanvasRenderer) {
        renderer.render(self)
    }
}
