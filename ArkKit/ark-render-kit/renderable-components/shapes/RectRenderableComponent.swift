import CoreGraphics

struct RectRenderableComponent: ShapeRenderableComponent {
    let width: Double
    let height: Double
    var center: CGPoint
    var rotation: Double
    var zPosition: Double = 0.0
    var isUserInteractionEnabled = false
    var renderLayer: RenderLayer = .canvas
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(width: Double, height: Double, center: CGPoint = .zero, rotation: Double = 0.0) {
        self.width = width
        self.height = height
        self.center = center
        self.rotation = rotation
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> RectRenderableComponent {
        var copy = self

        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo

        return copy
    }

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}

extension RectRenderableComponent: SendableComponent {
    enum CodingKeys: String, CodingKey {
            case width, height, center, rotation, zPosition, isUserInteractionEnabled, renderLayer, fillInfo, strokeInfo
        }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        width = try container.decode(Double.self, forKey: .width)
        height = try container.decode(Double.self, forKey: .height)
        center = try container.decode(CGPoint.self, forKey: .center)
        rotation = try container.decode(Double.self, forKey: .rotation)
        zPosition = try container.decode(Double.self, forKey: .zPosition)
        isUserInteractionEnabled = try container.decode(Bool.self, forKey: .isUserInteractionEnabled)
        renderLayer = try container.decode(RenderLayer.self, forKey: .renderLayer)
        fillInfo = try container.decodeIfPresent(ShapeFillInfo.self, forKey: .fillInfo)
        strokeInfo = try container.decodeIfPresent(ShapeStrokeInfo.self, forKey: .strokeInfo)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(center, forKey: .center)
        try container.encode(rotation, forKey: .rotation)
        try container.encode(zPosition, forKey: .zPosition)
        try container.encode(isUserInteractionEnabled, forKey: .isUserInteractionEnabled)
        try container.encode(renderLayer, forKey: .renderLayer)
        try container.encodeIfPresent(fillInfo, forKey: .fillInfo)
        try container.encodeIfPresent(strokeInfo, forKey: .strokeInfo)
    }
}
