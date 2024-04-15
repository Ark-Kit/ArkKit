import Foundation

extension ButtonRenderableComponent: SendableComponent {
    enum CodingKeys: String, CodingKey {
        case center, rotation, zPosition, renderLayer, isUserInteractionEnabled, width, height, buttonStyleConfig
        // TODO: Figure out a way to link the tap delegation
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
        buttonStyleConfig = try container.decode(ButtonStyleConfiguration.self, forKey: .buttonStyleConfig)
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
        try container.encode(buttonStyleConfig, forKey: .buttonStyleConfig)
    }
}

extension ButtonStyleConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case labelMapping, backgroundColor, borderRadius, borderWidth, borderColor, padding
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        labelMapping = try container.decodeIfPresent(LabelMapping.self, forKey: .labelMapping)
        backgroundColor = try container.decodeIfPresent(AbstractColor.self, forKey: .backgroundColor)
        borderRadius = try container.decodeIfPresent(Double.self, forKey: .borderRadius)
        borderWidth = try container.decodeIfPresent(Double.self, forKey: .borderWidth)
        borderColor = try container.decodeIfPresent(AbstractColor.self, forKey: .borderColor)
        padding = try container.decodeIfPresent([PaddingSides: Double].self, forKey: .padding)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(labelMapping, forKey: .labelMapping)
        try container.encodeIfPresent(backgroundColor, forKey: .backgroundColor)
        try container.encodeIfPresent(borderRadius, forKey: .borderRadius)
        try container.encodeIfPresent(borderWidth, forKey: .borderWidth)
        try container.encodeIfPresent(borderColor, forKey: .borderColor)
        try container.encodeIfPresent(padding, forKey: .padding)
    }
}
