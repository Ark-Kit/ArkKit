import CoreGraphics

struct BitmapImageCanvasComponent: CanvasComponent {
    let imageResourcePath: String
    let center: CGPoint
    let width: Double
    let height: Double
    let areValuesEqual: AreValuesEqualDelegate

    private(set) var isClipToBounds = false
    private(set) var isScaleAspectFit = false
    private(set) var isScaleToFill = false
    private(set) var isScaleAspectFill = false

    init(imageResourcePath: String, center: CGPoint, width: Double, height: Double,
         areValuesEqual: @escaping (BitmapImageCanvasComponent, BitmapImageCanvasComponent) -> Bool
         = { _, _ in false }) {
        self.imageResourcePath = imageResourcePath
        self.center = center
        self.width = width
        self.height = height
        self.areValuesEqual = areValuesEqual
    }

    func render(using renderer: any CanvasRenderer) -> any Renderable {
        renderer.render(self)
    }

    func update(using updater: any CanvasComponentUpdater) -> BitmapImageCanvasComponent {
        updater.update(self)
    }
}

// MARK: Builder pattern helpers
extension BitmapImageCanvasComponent: AbstractBitmap {
    func clipToBounds() -> Self {
        immutableCopy(isClipToBounds: true)
    }

    func scaleAspectFit() -> Self {
        immutableCopy(isScaleAspectFit: true)
    }

    func scaleToFill() -> Self {
        immutableCopy(isScaleToFill: true)
    }

    func scaleAspectFill() -> Self {
        immutableCopy(isScaleAspectFill: true)
    }

    func immutableCopy(
        isClipToBounds: Bool? = nil,
        isScaleAspectFit: Bool? = nil,
        isScaleToFill: Bool? = nil,
        isScaleAspectFill: Bool? = nil
    ) -> Self {
        var copy = BitmapImageCanvasComponent(
            imageResourcePath: imageResourcePath,
            center: center,
            width: width,
            height: height,
            areValuesEqual: areValuesEqual
        )
        copy.isClipToBounds = isClipToBounds ?? self.isClipToBounds
        copy.isScaleAspectFit = isScaleAspectFit ?? self.isScaleAspectFit
        copy.isScaleToFill = isScaleToFill ?? self.isScaleToFill
        copy.isScaleAspectFill = isScaleAspectFill ?? self.isScaleAspectFill

        return copy
    }
}
