import UIKit

protocol UIKitShape: UIKitRenderable, ShapeRenderable where Color == UIColor {}

/**
 * Provides default implementation for `fill` and `stroke` methods across different shapes
 */
extension UIKitShape {
    func applyModifiers(modifierInfo: some ShapeRenderableComponent, colorGetter: (AbstractColor?) -> Color) -> Self {
        self
            .if(modifierInfo.fillInfo != nil, transform: { view in
                view.fill(color: colorGetter(modifierInfo.fillInfo?.color))
            })
            .if(modifierInfo.strokeInfo != nil, transform: { view in
                if let strokeInfo = modifierInfo.strokeInfo {
                    return view.stroke(lineWidth: strokeInfo.lineWidth, color: colorGetter(strokeInfo.color))
                }
                return view
            })
    }

    func fill(color: UIColor) -> Self {
        self.layer.sublayers?.forEach { subLayer in
            guard let shapeLayer = subLayer as? CAShapeLayer else {
                return
            }
            shapeLayer.fillColor = color.cgColor
        }
        return self
    }

    func stroke(lineWidth: Double, color: UIColor) -> Self {
        self.layer.sublayers?.forEach { subLayer in
            guard let shapeLayer = subLayer as? CAShapeLayer else {
                return
            }
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = lineWidth
        }
        return self
    }
}
