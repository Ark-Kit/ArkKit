import UIKit

final class UIKitButton: UIButton, UIKitRenderable, TapRenderable {
    var onTapDelegate: TapDelegate?

    init(width: Double, height: Double, center: CGPoint) {
        let frame = CGRect(x: center.x - width / 2, y: center.y - height / 2,
                           width: width, height: height)
        super.init(frame: frame)
        setUpTap()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func modify(onTapDelegate: TapDelegate?) -> Self {
        self.onTapDelegate = onTapDelegate

        return self
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        if let unwrappedOnTapDelegate = onTapDelegate {
            unwrappedOnTapDelegate()
        }
    }

    private func setUpTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
}

extension UIKitButton {
    func applyModifiers(modifierInfo: ButtonRenderableComponent) -> Self {
        self
            .if(modifierInfo.onTapDelegate != nil, transform: { view in
                view.onTap(modifierInfo.onTapDelegate ?? {})
            })
    }
}

extension UIKitButton {
    func style(_ styleConfig: ButtonStyleConfiguration,
               colorGetter: (AbstractColor) -> UIColor) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.filled()
        // Set title for different states if provided
        if let label = styleConfig.labelMapping {
            self.setTitle(label.0, for: .normal)
            self.setTitleColor(colorGetter(label.1), for: .normal)
        }
        configuration.baseBackgroundColor = colorGetter(
            styleConfig.backgroundColor ?? .default
        )
        // Set padding if provided
        if let padding = styleConfig.padding {
            // Set content insets based on padding
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: padding[.top] ?? 0,
                leading: padding[.left] ?? 0,
                bottom: padding[.bottom] ?? 0,
                trailing: padding[.right] ?? 0
            )
        }

        if let borderRadius = styleConfig.borderRadius {
            configuration.background.cornerRadius = borderRadius
            configuration.cornerStyle = .fixed
        }
        if let borderWidth = styleConfig.borderWidth {
            configuration.background.strokeWidth = borderWidth
        }
        if let borderColor = styleConfig.borderColor {
            configuration.background.strokeColor = colorGetter(borderColor)
        }

        self.configuration = configuration
        return self
    }
}
