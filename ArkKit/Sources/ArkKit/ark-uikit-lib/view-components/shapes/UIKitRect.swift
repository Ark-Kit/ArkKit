import UIKit

final class UIKitRect: UIView, UIKitShape {
    var onTapDelegate: TapDelegate?

    init(width: Double, height: Double, center: CGPoint) {
        let rectFrame = CGRect(x: center.x - width / 2,
                               y: center.y - height / 2,
                               width: width,
                               height: height)
        super.init(frame: rectFrame)
        let rectPath = UIBezierPath(rect: CGRect(x: 0,
                                                 y: 0,
                                                 width: width,
                                                 height: height))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = rectPath.cgPath
        self.layer.addSublayer(shapeLayer)

        let textLayer = CATextLayer()
        textLayer.frame = rectFrame
        self.layer.addSublayer(textLayer)

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
