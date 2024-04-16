import Foundation

struct CameraContainerRenderableComponent: RenderableComponent, AbstractLetterboxable {
    var center: CGPoint
    var size: CGSize
    var frame: CGRect {
        CGRect(x: 0,
               y: 0,
               width: size.width,
               height: size.height)
    }

    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = true
    var shouldRerenderDelegate: ShouldRerenderDelegate?
    var zPosition: Double = 0.0
    var opacity: Double = 1.0
    var rotation: Double = 0.0

    private(set) var letterboxWidthScaleFactor: CGFloat = 1.0
    private(set) var letterboxHeightScaleFactor: CGFloat = 1.0
    private(set) var mask: CGRect?
    private(set) var zoom = CameraZoom(widthZoom: 1.0, heightZoom: 1.0)
    private(set) var trackPosition: CGPoint?

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

        let baseWidth = self.frame.width
        let baseHeight = self.frame.height

        let widthScaleFactor = screenSize.width / baseWidth
        let heightScaleFactor = screenSize.height / baseHeight

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

    func zoom(by zoom: CameraZoom) -> Self {
        var copy = self
        copy.zoom = zoom
        return copy
    }

    func track(_ point: CGPoint) -> Self {
        var copy = self
        copy.trackPosition = point
        return copy
    }
}
