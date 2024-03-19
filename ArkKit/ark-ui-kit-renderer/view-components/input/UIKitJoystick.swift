import UIKit

final class UIKitJoystick: UIView, UIKitRenderable, PanRenderable {
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

    func modify(
        onPanStartDelegate: PanDelegate?,
        onPanChangeDelegate: PanDelegate?,
        onPanEndDelegate: PanDelegate?
    ) -> Self {
        self.onPanStartDelegate = onPanStartDelegate
        self.onPanChangeDelegate = onPanChangeDelegate
        self.onPanEndDelegate = onPanEndDelegate
        return self
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            return
        }
        let translation = gesture.translation(in: self)
        let magnitude = sqrt(translation.x * translation.x + translation.y * translation.y)
        let clockwiseAngle = calculateClockwiseAngleRotationInRadians(by: translation)

        // clamp so that the joystick has a maximum departue
        let clampedMagnitude = min(magnitude, radius)
        let clampedTranslation = CGPoint(x: translation.x / magnitude * clampedMagnitude,
                                         y: translation.y / magnitude * clampedMagnitude)
        let currentPoint = CGPoint(x: radius + clampedTranslation.x, y: radius + clampedTranslation.y)
        let defaultPanDelegate: PanDelegate = { (_: Double, _: Double) in }
        if gesture.state == .began {
            (onPanStartDelegate ?? defaultPanDelegate)(clockwiseAngle, clampedMagnitude)
            self.subviews.last?.center = currentPoint
        }
        if gesture.state == .changed {
            (onPanChangeDelegate ?? defaultPanDelegate)(clockwiseAngle, clampedMagnitude)
            self.subviews.last?.center = currentPoint
        }
        if gesture.state == .ended {
            (onPanEndDelegate ?? defaultPanDelegate)(clockwiseAngle, clampedMagnitude)
            self.subviews.last?.center = CGPoint(x: radius, y: radius)
        }
    }
    private func setUpPan() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(pan)
    }
    private func calculateClockwiseAngleRotationInRadians(by translation: CGPoint) -> Double {
        var angle = atan2(translation.x, -translation.y)
        if angle < 0 {
            angle += 2 * .pi
        }
        return angle
    }
}

extension UIKitJoystick {
    func applyModifiers(modifierInfo: JoystickCanvasComponent) -> Self {
        let defaultPanHandler = { (_: Double, _: Double) in }

        return self
            .if(modifierInfo.onPanStartDelegate != nil, transform: { view in
                view.addPanStartDelegate(delegate: modifierInfo.onPanStartDelegate ?? defaultPanHandler)
            })
            .if(modifierInfo.onPanChangeDelegate != nil, transform: { view in
                view.addPanChangeDelegate(delegate: modifierInfo.onPanChangeDelegate ?? defaultPanHandler)
            })
            .if(modifierInfo.onPanEndDelegate != nil, transform: { view in
                view.addPanEndDelegate(delegate: modifierInfo.onPanEndDelegate ?? defaultPanHandler)
            })
    }
}
