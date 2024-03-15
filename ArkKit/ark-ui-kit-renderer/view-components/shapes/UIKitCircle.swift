import UIKit

final class UIKitCircle: UIKitShape {
    private(set) var uiView: UIView
    
    init(radius: Double, center: CGPoint) {
        let circleFrame = CGRect(x: center.x - radius, y: center.y - radius,
                                 width: radius * 2, height: radius * 2)
        let circle = UIView(frame: circleFrame)
        let center = CGPoint(x: radius, y: radius)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: 0,
                                      endAngle: CGFloat.pi * 2,
                                      clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        circle.layer.addSublayer(shapeLayer)
        self.uiView = circle
    }
}
