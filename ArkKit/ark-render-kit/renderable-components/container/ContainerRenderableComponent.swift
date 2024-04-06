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
    private(set) var letterboxWidthScaleFactor: CGFloat = 1.0
    private(set) var letterboxHeightScaleFactor: CGFloat = 1.0
    var mask: CGRect?

    let renderableComponents: [any RenderableComponent]

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }

    func setIsUserInteractionEnabled(_ isEnabled: Bool) -> Self {
        var copy = self
        copy.isUserInteractionEnabled = isEnabled
        return copy
    }

    func letterbox(into screenSize: CGSize) -> Self {
        var copy = self
        let widthScaleFactor = screenSize.width / self.frame.width
        let heightScaleFactor = screenSize.height / self.frame.height
        copy.letterboxWidthScaleFactor = widthScaleFactor
        copy.letterboxHeightScaleFactor = heightScaleFactor
        return copy
    }

    func size(_ size: CGSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    func mask(size: CGSize, origin: CGPoint) -> Self {
        var copy = self
        copy.mask = CGRect(origin: origin, size: size)
        return copy
    }
}
