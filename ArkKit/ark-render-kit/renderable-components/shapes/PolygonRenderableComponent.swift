import CoreGraphics

struct PolygonRenderableComponent: ShapeRenderableComponent {
    let points: [CGPoint]
    let frame: CGRect
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = false
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    private(set) var fillInfo: ShapeFillInfo?
    private(set) var strokeInfo: ShapeStrokeInfo?

    init(points: [CGPoint], frame: CGRect, rotation: Double = 0.0) {
        self.points = points
        self.frame = frame
        self.center = CGPoint(x: frame.midX, y: frame.midY)
        self.rotation = rotation
    }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> PolygonRenderableComponent {
        var copy = self

        copy.fillInfo = fillInfo
        copy.strokeInfo = strokeInfo

        return copy
    }

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}

extension PolygonRenderableComponent: SendableComponent {
    enum CodingKeys: String, CodingKey {
            case points, frame, center, rotation, zPosition, renderLayer, isUserInteractionEnabled, 
                 fillInfo, strokeInfo
        }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        points = try container.decode([CGPoint].self, forKey: .points)
        frame = try container.decode(CGRect.self, forKey: .frame)
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
        try container.encode(points, forKey: .points)
        try container.encode(frame, forKey: .frame)
        try container.encode(center, forKey: .center)
        try container.encode(rotation, forKey: .rotation)
        try container.encode(zPosition, forKey: .zPosition)
        try container.encode(renderLayer, forKey: .renderLayer)
        try container.encode(isUserInteractionEnabled, forKey: .isUserInteractionEnabled)
        try container.encodeIfPresent(fillInfo, forKey: .fillInfo)
        try container.encodeIfPresent(strokeInfo, forKey: .strokeInfo)
    }
}
