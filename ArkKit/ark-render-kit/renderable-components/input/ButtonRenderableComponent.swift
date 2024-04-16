import CoreGraphics

struct ButtonRenderableComponent: AbstractTappable, RenderableComponent {
    var center: CGPoint = .zero
    var rotation: Double = 0.0
    var zPosition: Double = 0.0
    var opacity: Double = 1.0
    var renderLayer: RenderLayer = .canvas
    var isUserInteractionEnabled = true
    var shouldRerenderDelegate: ShouldRerenderDelegate?

    let width: Double
    let height: Double

    var onTapDelegate: TapDelegate?

    var buttonStyleConfig = ButtonStyleConfiguration()

    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }

    func modify(onTapDelegate: TapDelegate?) -> ButtonRenderableComponent {
        var updated = self
        updated.onTapDelegate = onTapDelegate
        return updated
    }

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T> {
        builder.build(self)
    }
}

extension ButtonRenderableComponent: AbstractButtonStyle {
    func label(_ label: String, color: AbstractColor) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.labelMapping = LabelMapping(label: label, color: color)
        return newSelf
    }

    func background(color: AbstractColor) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.backgroundColor = color
        return newSelf
    }

    func borderRadius(_ radius: Double) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.borderRadius = radius
        return newSelf
    }

    func borderWidth(_ value: Double) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.borderWidth = value
        return newSelf
    }

    func borderColor(_ color: AbstractColor) -> ButtonRenderableComponent {
        var newSelf = self
        newSelf.buttonStyleConfig.borderColor = color
        return newSelf
    }

    func padding(_ padding: Double) -> ButtonRenderableComponent {
        var newSelf = self
        if newSelf.buttonStyleConfig.padding == nil {
            newSelf.buttonStyleConfig.padding = [:]
        }
        for paddingSide in ButtonStyleConfiguration.PaddingSides.allCases {
            newSelf.buttonStyleConfig.padding?[paddingSide] = padding
        }
        return newSelf
    }

    func padding(x: Double, y: Double) -> ButtonRenderableComponent {
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

    func padding(top: Double, bottom: Double, left: Double, right: Double) -> ButtonRenderableComponent {
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

struct LabelMapping: Codable {
    var label: String
    var color: AbstractColor
}

struct ButtonStyleConfiguration {
    enum BorderSides: CaseIterable {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    enum PaddingSides: String, Codable, CaseIterable {
        case top
        case bottom
        case left
        case right
    }

    var labelMapping: LabelMapping?
    var backgroundColor: AbstractColor?
    var borderRadius: Double?
    var borderWidth: Double?
    var borderColor: AbstractColor?
    var padding: [PaddingSides: Double]?
}
