import UIKit

final class UIKitRect: UIKitShape {
    private(set) var uiView: UIView
    init(width: Double, height: Double, center: CGPoint) {
        let rectFrame = CGRect(x: center.x - width / 2,
                               y: center.y - height / 2,
                               width: width,
                               height: height)
        let rect = UIView(frame: rectFrame)
        let rectPath = UIBezierPath(rect: CGRect(x: 0,
                                                 y: 0,
                                                 width: width,
                                                 height: height))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = rectPath.cgPath
        rect.layer.addSublayer(shapeLayer)
        self.uiView = rect
    }
}
