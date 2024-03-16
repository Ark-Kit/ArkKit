import UIKit

class UIKitJoystick: UIView, UIKitRenderable, PanRenderable {
    var onPanStartDelegate: PanDelegate?
    var onPanChangeDelegate: PanDelegate?
    var onPanEndDelegate: PanDelegate?

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

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let currentPoint = gesture.location(in: self)

        // TODO: Implement calculations for angle and magnitude
        let angle = 0.0
        let magnitude = 0.0

        let defaultPanDelegate: PanDelegate = { (_: Double, _: Double) in }

        if gesture.state == .began {
            (onPanStartDelegate ?? defaultPanDelegate)(angle, magnitude)
            self.subviews.last?.center = currentPoint
        }
        if gesture.state == .changed {
            (onPanChangeDelegate ?? defaultPanDelegate)(angle, magnitude)
            self.subviews.last?.center = currentPoint
        }
        if gesture.state == .ended {
            (onPanEndDelegate ?? defaultPanDelegate)(angle, magnitude)
            self.subviews.last?.center = CGPoint(x: radius, y: radius)
        }
    }
    private func setUpPan() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(pan)
    }
}
