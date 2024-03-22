import CoreGraphics

struct ButtonRenderableComponent: AbstractTappable, RenderableComponent {
    let width: Double
    let height: Double
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var isUserInteractionEnabled = true
    var renderLayer: RenderLayer = .canvas
    let areValuesEqual: AreValuesEqualDelegate

    var onTapDelegate: TapDelegate?

    init(width: Double, height: Double,
         areValuesEqual: @escaping (ButtonRenderableComponent, ButtonRenderableComponent) -> Bool = { _, _ in false }) {
        self.width = width
        self.height = height
        self.areValuesEqual = areValuesEqual
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
