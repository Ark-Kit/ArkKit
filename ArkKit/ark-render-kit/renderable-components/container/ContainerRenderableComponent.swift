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
    var zPosition: Double = 0.0
    var rotation: Double = 0.0

    let renderableComponents: [any RenderableComponent]

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }

    // TODO: move letterbox logic here --> propagate to the UIKitContainer
}
