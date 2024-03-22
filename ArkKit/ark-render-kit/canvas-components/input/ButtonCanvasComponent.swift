import CoreGraphics

struct ButtonCanvasComponent: AbstractTappable, CanvasComponent {
    let width: Double
    let height: Double
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    let areValuesEqual: AreValuesEqualDelegate

    var onTapDelegate: TapDelegate?

    init(width: Double, height: Double,
         areValuesEqual: @escaping (ButtonCanvasComponent, ButtonCanvasComponent) -> Bool = { _, _ in false }) {
        self.width = width
        self.height = height
        self.areValuesEqual = areValuesEqual
    }

    func modify(onTapDelegate: TapDelegate?) -> ButtonCanvasComponent {
        var updated = self
        updated.onTapDelegate = onTapDelegate
        return updated
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> ButtonCanvasComponent {
        updater.update(self)
    }
}
