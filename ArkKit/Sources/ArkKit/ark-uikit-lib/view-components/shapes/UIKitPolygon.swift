import UIKit

final class UIKitPolygon: UIView, UIKitShape {
    var onTapDelegate: TapDelegate?

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

        let textLayer = CATextLayer()
        textLayer.frame = frame
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
