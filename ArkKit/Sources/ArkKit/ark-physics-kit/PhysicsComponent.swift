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
    public var velocity: CGVector = .zero
    public var isDynamic = true
    public var affectedByGravity = false
    public var linearDamping: CGFloat = .zero
    public var angularDamping: CGFloat = .zero
    public var allowsRotation = false
    public var friction: CGFloat = .zero
    public var restitution: CGFloat = .zero
    public var impulse: CGVector = .zero
    public var angularImpulse: CGFloat = .zero

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
