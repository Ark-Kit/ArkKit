import Foundation

public protocol ShapeRenderableComponent: AbstractShape, AbstractTappable, RenderableComponent where Color == AbstractColor {
    var fillInfo: ShapeFillInfo? { get }
    var strokeInfo: ShapeStrokeInfo? { get }
    var labelInfo: ShapeLabelInfo? { get }
    var onTapDelegate: TapDelegate? { get set }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?, labelInfo: ShapeLabelInfo?) -> Self
}

extension ShapeRenderableComponent {
    public func fill(color: Color) -> Self {
        upsert(fillInfo: ShapeFillInfo(color: color))
    }

    public func stroke(lineWidth: Double, color: Color) -> Self {
        upsert(strokeInfo: ShapeStrokeInfo(lineWidth: lineWidth, color: color))
    }

    public func label(_ text: String, color: Color? = nil, size: Double? = nil) -> Self {
        let newColor = color ?? labelInfo?.color ?? .black
        let newSize = size ?? labelInfo?.size ?? 14

        return upsert(labelInfo: ShapeLabelInfo(text: text, color: newColor, size: newSize))
    }

    public func upsert(fillInfo: ShapeFillInfo? = nil, strokeInfo: ShapeStrokeInfo? = nil,
                labelInfo: ShapeLabelInfo? = nil) -> Self {
        modify(
            fillInfo: fillInfo ?? self.fillInfo,
            strokeInfo: strokeInfo ?? self.strokeInfo,
            labelInfo: labelInfo ?? self.labelInfo
        )
    }

    public func modify(onTapDelegate: TapDelegate?) -> Self {
        var copy = self
        copy.onTapDelegate = onTapDelegate
        return copy
    }
}

public struct ShapeFillInfo: Codable {
    public let color: AbstractColor

    public init(color: AbstractColor) {
        self.color = color
    }
}

public struct ShapeStrokeInfo: Codable {
    public let lineWidth: Double
    public let color: AbstractColor

    public init(lineWidth: Double, color: AbstractColor) {
        self.lineWidth = lineWidth
        self.color = color
    }
}

public struct ShapeLabelInfo: Codable {
    public let text: String
    public let color: AbstractColor
    public let size: Double

    public init(text: String, color: AbstractColor, size: Double) {
        self.text = text
        self.color = color
        self.size = size
    }
}
