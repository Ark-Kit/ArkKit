import Foundation

extension RectRenderableComponent: SendableComponent {
    enum CodingKeys: String, CodingKey {
            case width, height, center, rotation, zPosition, isUserInteractionEnabled,
                 renderLayer, fillInfo, strokeInfo, labelInfo
        }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let width = try container.decode(Double.self, forKey: .width)
        let height = try container.decode(Double.self, forKey: .height)
        let fillInfo = try container.decodeIfPresent(ShapeFillInfo.self, forKey: .fillInfo)
        let strokeInfo = try container.decodeIfPresent(ShapeStrokeInfo.self, forKey: .strokeInfo)
        let labelInfo = try container.decodeIfPresent(ShapeLabelInfo.self, forKey: .labelInfo)
        self.init(width: width, height: height, fillInfo: fillInfo, strokeInfo: strokeInfo, labelInfo: labelInfo)
        center = try container.decode(CGPoint.self, forKey: .center)
        rotation = try container.decode(Double.self, forKey: .rotation)
        zPosition = try container.decode(Double.self, forKey: .zPosition)
        isUserInteractionEnabled = try container.decode(Bool.self, forKey: .isUserInteractionEnabled)
        renderLayer = try container.decode(RenderLayer.self, forKey: .renderLayer)
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
        try container.encodeIfPresent(labelInfo, forKey: .labelInfo)
    }
}
