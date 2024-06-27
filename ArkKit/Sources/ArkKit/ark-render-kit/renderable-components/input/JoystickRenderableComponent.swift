import CoreGraphics

public struct JoystickRenderableComponent: AbstractPannable, RenderableComponent {
    public var center: CGPoint = .zero
    public var rotation: Double = 0.0
    public var zPosition: Double = 0.0
    public var opacity: Double = 1.0
    public var isUserInteractionEnabled = true
    public var renderLayer: RenderLayer = .canvas
    public var shouldRerenderDelegate: ShouldRerenderDelegate?

    let radius: Double

    public var onPanStartDelegate: PanEventDelegate?
    public var onPanChangeDelegate: PanEventDelegate?
    public var onPanEndDelegate: PanEventDelegate?

    public init(radius: Double) {
        self.radius = radius
    }

    public func modify(
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

    public func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}
