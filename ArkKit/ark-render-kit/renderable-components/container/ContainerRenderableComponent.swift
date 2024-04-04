import Foundation

struct ContainerRenderableComponent: RenderableComponent {
    var center: CGPoint
    var size: CGSize
    var frame: CGRect {
        CGRect(x: center.x - size.width / 2,
               y: center.y - size.height / 2,
               width: size.width,
               height: size.height)
    }

    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = true
    var shouldRerenderDelegate: ShouldRerenderDelegate?
    var zPosition: Double = 9_999
    var rotation: Double = 0.0

    let renderableComponents: [any RenderableComponent]

    func render<T>(using renderer: any CanvasRenderer<T>) -> any Renderable<T> {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> ContainerRenderableComponent {
        updater.update(self)
    }
}
