import UIKit

final class UIKitJoystick: UIView, UIKitRenderable, PanRenderable {
    var onPanStartDelegate: PanEventDelegate?
    var onPanChangeDelegate: PanEventDelegate?
    var onPanEndDelegate: PanEventDelegate?

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

        if gesture.state == .began {
            if let onPanStartDelegate {
                onPanStartDelegate(clockwiseAngle, clampedMagnitude)
            }
            self.subviews.last?.center = currentPoint
        }
        if gesture.state == .changed {
            if let onPanChangeDelegate {
                onPanChangeDelegate(clockwiseAngle, clampedMagnitude)
            }
            self.subviews.last?.center = currentPoint
        }
        if gesture.state == .ended {
            if let onPanEndDelegate {
                onPanEndDelegate(clockwiseAngle, clampedMagnitude)
            }
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
    func applyModifiers(modifierInfo: JoystickRenderableComponent) -> Self {
        if let onPanStartHandler = modifierInfo.onPanStartDelegate {
            self.onPanStartDelegate = onPanStartHandler
        }
        if let onPanChangeHandler = modifierInfo.onPanChangeDelegate {
            self.onPanChangeDelegate = onPanChangeHandler
        }
        if let onPanEndHandler = modifierInfo.onPanEndDelegate {
            self.onPanEndDelegate = onPanEndHandler
        }

        return self
    }
}
