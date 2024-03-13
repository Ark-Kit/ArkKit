import UIKit

class ArkUiShapeClient {
    var shapeView: UIView?
    func fill(color: UIColor) -> ArkUiShapeClient {
        guard let ui = shapeView else {
            return self
        }
        ui.layer.sublayers?.forEach { subLayer in
            guard let shapeLayer = subLayer as? CAShapeLayer else {
                return
            }
            shapeLayer.fillColor = color.cgColor
        }
        return self
    }
    func stroke(lineWidth: Double, color: UIColor) -> ArkUiShapeClient {
        guard let ui = shapeView else {
            return self
        }
        ui.layer.sublayers?.forEach { subLayer in
            guard let shapeLayer = subLayer as? CAShapeLayer else {
                return
            }
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = lineWidth
        }
        return self
    }
    func render(into containerView: UIView) {
        guard let ui = shapeView else {
            return
        }
        containerView.addSubview(ui)
    }

    // SUPPORTED SHAPES - circle, rect, polygon for now
    func circle(center: CGPoint, radius: Double) -> ArkUiShapeClient {
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
        self.shapeView = circle
        return self
    }
    func rect(center: CGPoint, width: Double, height: Double) -> ArkUiShapeClient {
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
        self.shapeView = rect
        return self
    }
    func polygon(points: [CGPoint], frame: CGRect) -> ArkUiShapeClient {
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
        self.shapeView = polygon
        return self
    }
}
