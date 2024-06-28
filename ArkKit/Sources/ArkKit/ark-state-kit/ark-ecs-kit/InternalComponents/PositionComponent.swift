import Foundation

public struct PositionComponent: SendableComponent {
    public var position: CGPoint

    public init(position: CGPoint) {
        self.position = position
    }
}
