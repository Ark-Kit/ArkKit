import CoreGraphics

struct JoystickCanvasComponent: CanvasComponent {
    let center: CGPoint
    let radius: Double
    func accept(_ renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
