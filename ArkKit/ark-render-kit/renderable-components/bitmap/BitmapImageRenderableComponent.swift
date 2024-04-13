import CoreGraphics

struct BitmapImageRenderableComponent: RenderableComponent {
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
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

    init(imageResourcePath: String, width: Double, height: Double) {
        self.imageResourcePath = imageResourcePath
        self.width = width
        self.height = height
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

extension BitmapImageRenderableComponent: SendableComponent {
    enum CodingKeys: String, CodingKey {
        case center, rotation, zPosition, renderLayer, isUserInteractionEnabled, width, height,
             imageResourcePath, isClipToBounds, isScaleAspectFit, isScaleToFill, isScaleAspectFill
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        center = try container.decode(CGPoint.self, forKey: .center)
        rotation = try container.decode(Double.self, forKey: .rotation)
        zPosition = try container.decode(Double.self, forKey: .zPosition)
        renderLayer = try container.decode(RenderLayer.self, forKey: .renderLayer)
        isUserInteractionEnabled = try container.decode(Bool.self, forKey: .isUserInteractionEnabled)
        width = try container.decode(Double.self, forKey: .width)
        height = try container.decode(Double.self, forKey: .height)
        imageResourcePath = try container.decode(String.self, forKey: .imageResourcePath)
        isClipToBounds = try container.decode(Bool.self, forKey: .isClipToBounds)
        isScaleAspectFit = try container.decode(Bool.self, forKey: .isScaleAspectFit)
        isScaleToFill = try container.decode(Bool.self, forKey: .isScaleToFill)
        isScaleAspectFill = try container.decode(Bool.self, forKey: .isScaleAspectFill)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(center, forKey: .center)
        try container.encode(rotation, forKey: .rotation)
        try container.encode(zPosition, forKey: .zPosition)
        try container.encode(renderLayer, forKey: .renderLayer)
        try container.encode(isUserInteractionEnabled, forKey: .isUserInteractionEnabled)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(imageResourcePath, forKey: .imageResourcePath)
        try container.encode(isClipToBounds, forKey: .isClipToBounds)
        try container.encode(isScaleAspectFit, forKey: .isScaleAspectFit)
        try container.encode(isScaleToFill, forKey: .isScaleToFill)
        try container.encode(isScaleAspectFill, forKey: .isScaleAspectFill)
    }
}
