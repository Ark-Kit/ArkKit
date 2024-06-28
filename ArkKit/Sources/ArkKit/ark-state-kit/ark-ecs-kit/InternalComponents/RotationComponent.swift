import Foundation

public struct RotationComponent: SendableComponent {
    public var angleInRadians: CGFloat?

    public init(angleInRadians: CGFloat? = nil) {
        self.angleInRadians = angleInRadians
    }
}
