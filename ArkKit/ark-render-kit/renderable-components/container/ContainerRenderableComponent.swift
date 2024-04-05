import Foundation

struct ContainerRenderableComponent: RenderableComponent, AbstractLetterboxable {
    var center: CGPoint // canvas position
    var size: CGSize // canvas position
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
    private(set) var letterboxScaleFactor: CGFloat = 1.0
    var mask: CGRect?

    let renderableComponents: [any RenderableComponent]

//    init(center: CGPoint, size: CGSize, renderLayer: RenderLayer,
//         renderableComponents: [any RenderableComponent],
//         isUserInteractionEnabled: Bool = true, shouldRerenderDelegate: ShouldRerenderDelegate? = nil,
//         zPosition: Double = 0.0, rotation: Double = 0.0, letterboxScaleFactor: CGFloat = 1.0) {
//        self.center = center
//        self.size = size
//        self.renderLayer = renderLayer
//        self.isUserInteractionEnabled = isUserInteractionEnabled
//        self.shouldRerenderDelegate = shouldRerenderDelegate
//        self.zPosition = zPosition
//        self.rotation = rotation
//        self.letterboxScaleFactor = letterboxScaleFactor
//        self.windowSize = size
//        self.renderableComponents = renderableComponents
//    }

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }

    func setIsUserInteractionEnabled(_ isEnabled: Bool) -> Self {
        var copy = self
        copy.isUserInteractionEnabled = isEnabled
        return copy
    }

    // TODO: move letterbox logic here --> propagate to the UIKitContainer
    func letterbox(into screenSize: CGSize) -> Self {
        var copy = self
        let widthScaleFactor = screenSize.width / self.frame.width
        let heightScaleFactor = screenSize.height / self.frame.height
        let letterboxScaleFactor = min(widthScaleFactor, heightScaleFactor)
        copy.letterboxScaleFactor = letterboxScaleFactor
        return copy
    }

    func size(_ size: CGSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    func mask(size: CGSize, origin: CGPoint) -> Self {
        var copy = self
        copy.mask = CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
        return copy
    }
}
