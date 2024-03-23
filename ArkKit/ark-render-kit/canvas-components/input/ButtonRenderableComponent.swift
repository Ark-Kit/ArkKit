import CoreGraphics

struct ButtonRenderableComponent: AbstractTappable, RenderableComponent {
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = true
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    let width: Double
    let height: Double

    var onTapDelegate: TapDelegate?

    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }

    func modify(onTapDelegate: TapDelegate?) -> ButtonRenderableComponent {
        var updated = self
        updated.onTapDelegate = onTapDelegate
        return updated
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> ButtonRenderableComponent {
        updater.update(self)
    }
}
