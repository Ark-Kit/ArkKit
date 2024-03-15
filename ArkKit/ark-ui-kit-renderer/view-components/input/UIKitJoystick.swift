import UIKit

class UIKitJoystick: UIView, UIKitRenderable {
    let INNER_RADIUS_FACTOR = 0.75
    private let radius: Double
    init(center: CGPoint, radius: Double) {
        let frame = CGRect(x: center.x - radius, y: center.y - radius,
                           width: radius * 2, height: radius * 2)
        self.radius = radius
        super.init(frame: frame)
        let centerWithinContainer = CGPoint(x: radius, y: radius)
        let innerCircle = UIKitCircle(radius: INNER_RADIUS_FACTOR * radius,
                                      center: centerWithinContainer)
            .fill(color: .gray)
            .stroke(lineWidth: 1.0, color: .black)
        let outerCircle = UIKitCircle(radius: radius,
                                      center: centerWithinContainer)
            .fill(color: .lightGray)
            .stroke(lineWidth: 1.0, color: .black)

        outerCircle.render(into: self)
        innerCircle.render(into: self)
        innerCircle.isUserInteractionEnabled = true
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        setUpPan()
    }

    required init?(coder: NSCoder) {
        self.radius = 0.0
        super.init(coder: coder)
    }
}

extension UIKitJoystick: PanRenderable {
    func onPanStart() {
        // use delegate
    }

    func onPanEnd() {
        // use delegate
    }

    func onPanChange() {
        // use delegate
    }
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let currentPoint = gesture.location(in: self)
        if gesture.state == .began {
            onPanStart()
            self.subviews.last?.center = currentPoint
        }
        if gesture.state == .changed {
            onPanChange()
            self.subviews.last?.center = currentPoint
        }
        if gesture.state == .ended {
            onPanEnd()
            self.subviews.last?.center = CGPoint(x: radius, y: radius)
        }
    }
    private func setUpPan() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(pan)
    }
 }
