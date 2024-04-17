import Foundation

protocol ShapeRenderableComponent: AbstractShape, AbstractTappable, RenderableComponent where Color == AbstractColor {
    var fillInfo: ShapeFillInfo? { get }
    var strokeInfo: ShapeStrokeInfo? { get }
    var labelInfo: ShapeLabelInfo? { get }
    var onTapDelegate: TapDelegate? { get set }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?, labelInfo: ShapeLabelInfo?) -> Self
}

extension ShapeRenderableComponent {
    func fill(color: Color) -> Self {
        upsert(fillInfo: ShapeFillInfo(color: color))
    }

    func stroke(lineWidth: Double, color: Color) -> Self {
        upsert(strokeInfo: ShapeStrokeInfo(lineWidth: lineWidth, color: color))
    }

    func label(_ text: String, color: Color? = nil, size: Double? = nil) -> Self {
        let newColor = color ?? labelInfo?.color ?? .black
        let newSize = size ?? labelInfo?.size ?? 14

        return upsert(labelInfo: ShapeLabelInfo(text: text, color: newColor, size: newSize))
    }

    func upsert(fillInfo: ShapeFillInfo? = nil, strokeInfo: ShapeStrokeInfo? = nil,
                labelInfo: ShapeLabelInfo? = nil) -> Self {
        modify(
            fillInfo: fillInfo ?? self.fillInfo,
            strokeInfo: strokeInfo ?? self.strokeInfo,
            labelInfo: labelInfo ?? self.labelInfo
        )
    }

    func modify(onTapDelegate: TapDelegate?) -> Self {
        var copy = self
        copy.onTapDelegate = onTapDelegate
        return copy
    }
}

struct ShapeFillInfo: Codable {
    let color: AbstractColor
}

struct ShapeStrokeInfo: Codable {
    let lineWidth: Double
    let color: AbstractColor
}

struct ShapeLabelInfo: Codable {
    let text: String
    let color: AbstractColor
    let size: Double
}
