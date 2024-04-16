import CoreGraphics

struct BitmapImageRenderableComponent: RenderableComponent {
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var opacity: Double = 1.0
    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = false
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    let width: Double
    let height: Double
    var imageResourcePath: String

    private(set) var isClipToBounds = false
    private(set) var isScaleAspectFit = false
    private(set) var isScaleToFill = false
    private(set) var isScaleAspectFill = false

    init(arkImageResourcePath: any ArkImageEnum, width: Double, height: Double, center: CGPoint = .zero,
         isClipToBounds: Bool = false, isScaleAspectFit: Bool = false,
         isScaleToFill: Bool = false, isScaleAspectFill: Bool = false) {
        self.imageResourcePath = arkImageResourcePath.rawValue
        self.width = width
        self.height = height
        self.center = center
        self.isClipToBounds = isClipToBounds
        self.isScaleAspectFit = isScaleAspectFit
        self.isScaleToFill = isScaleToFill
        self.isScaleAspectFill = isScaleAspectFill
    }

    init(imageResourcePath: String, width: Double, height: Double, center: CGPoint = .zero,
         isClipToBounds: Bool = false, isScaleAspectFit: Bool = false,
         isScaleToFill: Bool = false, isScaleAspectFill: Bool = false) {
        self.imageResourcePath = imageResourcePath
        self.width = width
        self.height = height
        self.center = center
        self.isClipToBounds = isClipToBounds
        self.isScaleAspectFit = isScaleAspectFit
        self.isScaleToFill = isScaleToFill
        self.isScaleAspectFill = isScaleAspectFill
    }

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}

// MARK: Builder pattern helpers
extension BitmapImageRenderableComponent: AbstractBitmap {
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
        var copy = self
        copy.isClipToBounds = isClipToBounds ?? self.isClipToBounds
        copy.isScaleAspectFit = isScaleAspectFit ?? self.isScaleAspectFit
        copy.isScaleToFill = isScaleToFill ?? self.isScaleToFill
        copy.isScaleAspectFill = isScaleAspectFill ?? self.isScaleAspectFill

        return copy
    }
}
