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

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        if let unwrappedOnTapDelegate = onTapDelegate {
            unwrappedOnTapDelegate()
        }
    }
    private func setUpTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    // TODO: implement button styling as required below
    // currently we inherit `UIButton` so all default styling of `UIButton` is automatically
    // exposed from `UIKitButton`
}
