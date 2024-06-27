import CoreGraphics

public struct BitmapImageRenderableComponent: RenderableComponent {
    public var center: CGPoint = .zero
    public var rotation: Double = 0.0
    public var zPosition: Double = 0.0
    public var opacity: Double = 1.0
    public var renderLayer: RenderLayer = .canvas
    public var isUserInteractionEnabled = false
    public var shouldRerenderDelegate: ShouldRerenderDelegate?

    public let width: Double
    public let height: Double
    public var imageResourcePath: String

    private(set) var isClipToBounds = false
    private(set) var isScaleAspectFit = false
    private(set) var isScaleToFill = false
    private(set) var isScaleAspectFill = false

    public init(arkImageResourcePath: any ArkImageEnum, width: Double, height: Double, center: CGPoint = .zero,
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

    public init(imageResourcePath: String, width: Double, height: Double, center: CGPoint = .zero,
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

    public func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}

// MARK: Builder pattern helpers
extension BitmapImageRenderableComponent: AbstractBitmap {
    public func clipToBounds() -> Self {
        immutableCopy(isClipToBounds: true)
    }

    public func scaleAspectFit() -> Self {
        immutableCopy(isScaleAspectFit: true)
    }

    public func scaleToFill() -> Self {
        immutableCopy(isScaleToFill: true)
    }

    public func scaleAspectFill() -> Self {
        immutableCopy(isScaleAspectFill: true)
    }

    public func immutableCopy(
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
