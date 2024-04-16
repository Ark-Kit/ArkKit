import Foundation

enum ArkPhysicsShape: Codable {
    case circle
    case rectangle
    case polygon
}

struct PhysicsComponent: SendableComponent {

    // A physics component can either have a size or a radius depending on the shape
    let shape: ArkPhysicsShape
    var size: CGSize?
    var radius: CGFloat?
    var vertices: [CGPoint]?

    var mass: CGFloat?
    var velocity: CGVector = .zero
    var isDynamic = true
    var affectedByGravity = false
    var linearDamping: CGFloat = .zero
    var angularDamping: CGFloat = .zero
    var allowsRotation = false
    var friction: CGFloat = .zero
    var restitution: CGFloat = .zero
    var impulse: CGVector = .zero
    var angularImpulse: CGFloat = .zero

    var categoryBitMask: UInt32
    var collisionBitMask: UInt32
    var contactTestBitMask: UInt32
}
