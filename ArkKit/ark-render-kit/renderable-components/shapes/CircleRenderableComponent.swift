import CoreGraphics

struct CircleRenderableComponent: ShapeRenderableComponent {
    private(set) var radius: Double
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = false
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(radius: Double) {
        self.radius = radius
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> CircleRenderableComponent {
        var copy = self
        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo
        return copy
    }

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}

extension CircleRenderableComponent: SendableComponent {
    enum CodingKeys: String, CodingKey {
        case radius, center, rotation, zPosition, renderLayer, isUserInteractionEnabled, fillInfo, strokeInfo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        radius = try container.decode(Double.self, forKey: .radius)
        center = try container.decode(CGPoint.self, forKey: .center)
        rotation = try container.decode(Double.self, forKey: .rotation)
        zPosition = try container.decode(Double.self, forKey: .zPosition)
        renderLayer = try container.decode(RenderLayer.self, forKey: .renderLayer)
        isUserInteractionEnabled = try container.decode(Bool.self, forKey: .isUserInteractionEnabled)
        fillInfo = try container.decodeIfPresent(ShapeFillInfo.self, forKey: .fillInfo)
        strokeInfo = try container.decodeIfPresent(ShapeStrokeInfo.self, forKey: .strokeInfo)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(radius, forKey: .radius)
        try container.encode(center, forKey: .center)
        try container.encode(rotation, forKey: .rotation)
        try container.encode(zPosition, forKey: .zPosition)
        try container.encode(renderLayer, forKey: .renderLayer)
        try container.encode(isUserInteractionEnabled, forKey: .isUserInteractionEnabled)
        try container.encodeIfPresent(fillInfo, forKey: .fillInfo)
        try container.encodeIfPresent(strokeInfo, forKey: .strokeInfo)
    }
}
