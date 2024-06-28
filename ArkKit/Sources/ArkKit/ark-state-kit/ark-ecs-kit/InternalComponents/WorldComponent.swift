import Foundation

public struct WorldComponent: SendableComponent {
    public let center: CGPoint
    public let width: Double
    public let height: Double

    public init(center: CGPoint, width: Double, height: Double) {
        self.center = center
        self.width = width
        self.height = height
    }
}
