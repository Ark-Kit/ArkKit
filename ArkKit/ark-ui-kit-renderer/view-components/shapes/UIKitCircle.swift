import UIKit

final class UIKitCircle: UIView, UIKitShape {
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
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
