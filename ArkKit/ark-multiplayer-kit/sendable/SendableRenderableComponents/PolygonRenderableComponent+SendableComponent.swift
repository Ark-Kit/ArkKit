import Foundation

extension PolygonRenderableComponent: SendableComponent {
    enum CodingKeys: String, CodingKey {
            case points, frame, center, rotation, zPosition, renderLayer, isUserInteractionEnabled,
                 fillInfo, strokeInfo, labelInfo
        }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let points = try container.decode([CGPoint].self, forKey: .points)
        let fillInfo = try container.decodeIfPresent(ShapeFillInfo.self, forKey: .fillInfo)
        let strokeInfo = try container.decodeIfPresent(ShapeStrokeInfo.self, forKey: .strokeInfo)
        let labelInfo = try container.decodeIfPresent(ShapeLabelInfo.self, forKey: .labelInfo)
        let frame = try container.decode(CGRect.self, forKey: .frame)
        self.init(points: points, frame: frame, fillInfo: fillInfo, strokeInfo: strokeInfo, labelInfo: labelInfo)
        center = try container.decode(CGPoint.self, forKey: .center)
        rotation = try container.decode(Double.self, forKey: .rotation)
        zPosition = try container.decode(Double.self, forKey: .zPosition)
        renderLayer = try container.decode(RenderLayer.self, forKey: .renderLayer)
        isUserInteractionEnabled = try container.decode(Bool.self, forKey: .isUserInteractionEnabled)
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
        try container.encodeIfPresent(labelInfo, forKey: .labelInfo)
    }
}
