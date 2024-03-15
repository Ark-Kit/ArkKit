import UIKit

final class UIKitPolygon: UIView, UIKitShape {
    init(points: [CGPoint], frame: CGRect) {
        super.init(frame: frame)
        let polygonPath = UIBezierPath()
        if !points.isEmpty {
            polygonPath.move(to: points[0])
            for i in 1..<points.count {
                polygonPath.addLine(to: points[i])
            }
            polygonPath.close()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = polygonPath.cgPath
        self.layer.addSublayer(shapeLayer)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
