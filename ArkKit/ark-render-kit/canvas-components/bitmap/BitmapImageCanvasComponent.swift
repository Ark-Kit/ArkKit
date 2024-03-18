import CoreGraphics

struct BitmapImageCanvasComponent: CanvasComponent {
    let imageResourcePath: String
    let center: CGPoint
    let width: Double
    let height: Double
    func accept(_ renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
