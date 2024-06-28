import UIKit

final class UIKitCircle: UIView, UIKitShape {
    var onTapDelegate: TapDelegate?

    init(radius: Double, center: CGPoint) {
        let circleFrame = CGRect(x: center.x - radius, y: center.y - radius,
                                 width: radius * 2, height: radius * 2)
        super.init(frame: circleFrame)
        let center = CGPoint(x: radius, y: radius)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: 0,
                                      endAngle: CGFloat.pi * 2,
                                      clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        self.layer.addSublayer(shapeLayer)

        let textLayer = CATextLayer()
        textLayer.frame = circleFrame
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
