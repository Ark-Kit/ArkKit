import CoreGraphics

struct BitmapImageCanvasComponent: CanvasComponent {
    let imageResourcePath: String
    let center: CGPoint
    let width: Double
    let height: Double
}
