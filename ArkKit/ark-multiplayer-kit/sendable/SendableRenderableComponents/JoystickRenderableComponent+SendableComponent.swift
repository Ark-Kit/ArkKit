import Foundation

extension JoystickRenderableComponent: SendableComponent {
    enum CodingKeys: String, CodingKey {
        case center, rotation, zPosition, isUserInteractionEnabled, renderLayer, radius
        // TODO: Figure out a way to link the tap delegation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        center = try container.decode(CGPoint.self, forKey: .center)
        rotation = try container.decode(Double.self, forKey: .rotation)
        zPosition = try container.decode(Double.self, forKey: .zPosition)
        isUserInteractionEnabled = try container.decode(Bool.self, forKey: .isUserInteractionEnabled)
        renderLayer = try container.decode(RenderLayer.self, forKey: .renderLayer)
        radius = try container.decode(Double.self, forKey: .radius)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(center, forKey: .center)
        try container.encode(rotation, forKey: .rotation)
        try container.encode(zPosition, forKey: .zPosition)
        try container.encode(isUserInteractionEnabled, forKey: .isUserInteractionEnabled)
        try container.encode(renderLayer, forKey: .renderLayer)
        try container.encode(radius, forKey: .radius)
    }
}
