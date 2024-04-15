import Foundation

extension BitmapImageRenderableComponent: SendableComponent {
    enum CodingKeys: String, CodingKey {
        case center, rotation, zPosition, renderLayer, isUserInteractionEnabled, width, height,
             imageResourcePath, isClipToBounds, isScaleAspectFit, isScaleToFill, isScaleAspectFill
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let width = try container.decode(Double.self, forKey: .width)
        let height = try container.decode(Double.self, forKey: .height)
        let imageResourcePath = try container.decode(String.self, forKey: .imageResourcePath)
        let isClipToBounds = try container.decode(Bool.self, forKey: .isClipToBounds)
        let isScaleAspectFit = try container.decode(Bool.self, forKey: .isScaleAspectFit)
        let isScaleToFill = try container.decode(Bool.self, forKey: .isScaleToFill)
        let isScaleAspectFill = try container.decode(Bool.self, forKey: .isScaleAspectFill)
        self.init(imageResourcePath: imageResourcePath, width: width, height: height,
                  isClipToBounds: isClipToBounds, isScaleAspectFit: isScaleAspectFit,
                  isScaleToFill: isScaleToFill, isScaleAspectFill: isScaleAspectFill)
        center = try container.decode(CGPoint.self, forKey: .center)
        rotation = try container.decode(Double.self, forKey: .rotation)
        zPosition = try container.decode(Double.self, forKey: .zPosition)
        renderLayer = try container.decode(RenderLayer.self, forKey: .renderLayer)
        isUserInteractionEnabled = try container.decode(Bool.self, forKey: .isUserInteractionEnabled)
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
