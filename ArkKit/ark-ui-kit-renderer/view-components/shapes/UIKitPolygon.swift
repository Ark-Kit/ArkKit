import UIKit

final class UIKitPolygon: UIKitShape {
    private(set) var uiView: UIView

    init(points: [CGPoint], frame: CGRect) {
        let polygon = UIView(frame: frame)
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
        polygon.layer.addSublayer(shapeLayer)
        self.uiView = polygon
    }
}
