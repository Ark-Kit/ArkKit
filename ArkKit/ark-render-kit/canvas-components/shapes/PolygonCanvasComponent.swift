import CoreGraphics

struct PolygonCanvasComponent: CanvasComponent {
    let points: [CGPoint]
    let frame: CGRect
    func accept(_ renderer: any CanvasRenderer) {
        renderer.render(self)
    }
}
