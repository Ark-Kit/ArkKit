import CoreGraphics

public struct ButtonRenderableComponent: AbstractTappable, RenderableComponent {
    public var center: CGPoint = .zero
    public var rotation: Double = 0.0
    public var zPosition: Double = 0.0
    public var opacity: Double = 1.0
    public var renderLayer: RenderLayer = .canvas
    public var isUserInteractionEnabled = true
    public var shouldRerenderDelegate: ShouldRerenderDelegate?

    let width: Double
    let height: Double

    public var onTapDelegate: TapDelegate?

    var buttonStyleConfig = ButtonStyleConfiguration()

    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }

    public func modify(onTapDelegate: TapDelegate?) -> ButtonRenderableComponent {
        var updated = self
        updated.onTapDelegate = onTapDelegate
        return updated
    }

    public func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}

extension ButtonRenderableComponent: AbstractButtonStyle {
    public func label(_ label: String, color: AbstractColor) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.labelMapping = LabelMapping(label: label, color: color)
        return newSelf
    }

    public func background(color: AbstractColor) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.backgroundColor = color
        return newSelf
    }

    public func borderRadius(_ radius: Double) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.borderRadius = radius
        return newSelf
    }

    public func borderWidth(_ value: Double) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.borderWidth = value
        return newSelf
    }

    public func borderColor(_ color: AbstractColor) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.borderColor = color
        return newSelf
    }

    public func padding(_ padding: Double) -> ButtonRenderableComponent {
        var newSelf = self
        if newSelf.buttonStyleConfig.padding == nil {
            newSelf.buttonStyleConfig.padding = [:]
        }
        for paddingSide in ButtonStyleConfiguration.PaddingSides.allCases {
            newSelf.buttonStyleConfig.padding?[paddingSide] = padding
        }
        return newSelf
    }

    public func padding(x: Double, y: Double) -> ButtonRenderableComponent {
        var newSelf = self
        if newSelf.buttonStyleConfig.padding == nil {
            newSelf.buttonStyleConfig.padding = [:]
        }
        newSelf.buttonStyleConfig.padding?[.left] = x
        newSelf.buttonStyleConfig.padding?[.right] = x
        newSelf.buttonStyleConfig.padding?[.top] = y
        newSelf.buttonStyleConfig.padding?[.bottom] = y
        return newSelf
    }

    public func padding(top: Double, bottom: Double, left: Double, right: Double) -> ButtonRenderableComponent {
        var newSelf = self
        if newSelf.buttonStyleConfig.padding == nil {
            newSelf.buttonStyleConfig.padding = [:]
        }
        newSelf.buttonStyleConfig.padding?[.left] = left
        newSelf.buttonStyleConfig.padding?[.right] = right
        newSelf.buttonStyleConfig.padding?[.top] = top
        newSelf.buttonStyleConfig.padding?[.bottom] = bottom
        return newSelf
    }
}

public struct LabelMapping: Codable {
    public var label: String
    public var color: AbstractColor
}

public struct ButtonStyleConfiguration {
    public enum BorderSides: CaseIterable {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    public enum PaddingSides: String, Codable, CaseIterable {
        case top
        case bottom
        case left
        case right
    }

    public var labelMapping: LabelMapping?
    public var backgroundColor: AbstractColor?
    public var borderRadius: Double?
    public var borderWidth: Double?
    public var borderColor: AbstractColor?
    public var padding: [PaddingSides: Double]?
}
