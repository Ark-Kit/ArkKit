import CoreGraphics

struct PolygonCanvasComponent: CanvasComponent {
    let points: [CGPoint]
    let frame: CGRect
    func render(using renderer: CanvasRenderer) {
        renderer.render(self)
    }
}
