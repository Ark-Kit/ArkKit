import CoreGraphics

struct JoystickRenderableComponent: AbstractPannable, RenderableComponent {
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var isUserInteractionEnabled = true
    var renderLayer: RenderLayer = .canvas
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    let radius: Double

    var onPanStartDelegate: PanEventDelegate?
    var onPanChangeDelegate: PanEventDelegate?
    var onPanEndDelegate: PanEventDelegate?

    init(radius: Double) {
        self.radius = radius
    }

    func modify(
        onPanStartDelegate: PanEventDelegate?,
        onPanChangeDelegate: PanEventDelegate?,
        onPanEndDelegate: PanEventDelegate?
    ) -> JoystickRenderableComponent {
        var updated = self
        updated.onPanStartDelegate = onPanStartDelegate
        updated.onPanChangeDelegate = onPanChangeDelegate
        updated.onPanEndDelegate = onPanEndDelegate

        return updated
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> JoystickRenderableComponent {
        updater.update(self)
    }
}
