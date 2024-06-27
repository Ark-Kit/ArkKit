import Foundation

public enum ArkPhysicsShape: Codable {
    case circle
    case rectangle
    case polygon
}

public struct PhysicsComponent: SendableComponent {

    // A physics component can either have a size or a radius depending on the shape
    public let shape: ArkPhysicsShape
    public var size: CGSize?
    public var radius: CGFloat?
    public var vertices: [CGPoint]?

    public var mass: CGFloat?
    public var velocity: CGVector
    public var isDynamic: Bool
    public var affectedByGravity: Bool
    public var linearDamping: CGFloat
    public var angularDamping: CGFloat
    public var allowsRotation: Bool
    public var friction: CGFloat
    public var restitution: CGFloat
    public var impulse: CGVector
    public var angularImpulse: CGFloat

    public var categoryBitMask: UInt32
    public var collisionBitMask: UInt32
    public var contactTestBitMask: UInt32

    public init(shape: ArkPhysicsShape,
                size: CGSize? = nil,
                radius: CGFloat? = nil,
                vertices: [CGPoint]? = nil,
                mass: CGFloat? = nil,
                velocity: CGVector = .zero,
                isDynamic: Bool = true,
                affectedByGravity: Bool = false,
                linearDamping: CGFloat = .zero,
                angularDamping: CGFloat = .zero,
                allowsRotation: Bool = false,
                friction: CGFloat = .zero,
                restitution: CGFloat = .zero,
                impulse: CGVector = .zero,
                angularImpulse: CGFloat = .zero,
                categoryBitMask: UInt32,
                collisionBitMask: UInt32,
                contactTestBitMask: UInt32) {
        self.shape = shape
        self.size = size
        self.radius = radius
        self.vertices = vertices
        self.mass = mass
        self.velocity = velocity
        self.isDynamic = isDynamic
        self.affectedByGravity = affectedByGravity
        self.linearDamping = linearDamping
        self.angularDamping = angularDamping
        self.allowsRotation = allowsRotation
        self.friction = friction
        self.restitution = restitution
        self.impulse = impulse
        self.angularImpulse = angularImpulse
        self.categoryBitMask = categoryBitMask
        self.collisionBitMask = collisionBitMask
        self.contactTestBitMask = contactTestBitMask
    }
}
