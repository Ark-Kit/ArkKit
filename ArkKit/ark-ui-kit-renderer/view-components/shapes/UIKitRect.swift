import UIKit

final class UIKitRect: UIView, UIKitShape {
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
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
