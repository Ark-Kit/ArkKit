import UIKit

final class UIKitButton: UIButton, UIKitRenderable, TapRenderable {
    var onTapDelegate: TapDelegate?

    init(width: Double, height: Double, center: CGPoint) {
        let frame = CGRect(x: center.x - width / 2, y: center.y - height / 2,
                           width: width, height: height)
        super.init(frame: frame)
        // TODO: enable styling of button from abstractButton
        self.backgroundColor = .brown
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
