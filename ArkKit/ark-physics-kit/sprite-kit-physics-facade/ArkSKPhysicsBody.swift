import SpriteKit

class ArkSKPhysicsBody: AbstractArkPhysicsBody {
    private(set) var node: SKNode
    private let nodeNoPhysicsBodyFailureMessage = "SKNode does not contain an associated SKPhysicsBody."

    public init(rectangleOf size: CGSize, at position: CGPoint = .zero) {
        let physicsBody = SKPhysicsBody(rectangleOf: size, center: position)
        node = SKNode()
        node.position = position
        node.physicsBody = physicsBody
    }

    public init(circleOf radius: CGFloat, at position: CGPoint = .zero) {
        let physicsBody = SKPhysicsBody(circleOfRadius: radius, center: position)
        node = SKNode()
        node.position = position
        node.physicsBody = physicsBody
    }
    
    private func withPhysicsBody<T>(_ action: (SKPhysicsBody) -> T, default defaultValue: T) -> T {
        guard let physicsBody = node.physicsBody else {
            assertionFailure(nodeNoPhysicsBodyFailureMessage)
            return defaultValue
        }
        return action(physicsBody)
    }
    
    var position: CGPoint {
        get { node.position }
        set { node.position = newValue }
    }

    var zRotation: CGFloat {
        get { node.zRotation }
        set { node.zRotation = newValue }
    }
    
    public var mass: CGFloat {
        get {
            withPhysicsBody({ $0.mass }, default: DefaultSKPhysicsBodyValues.mass)
        }
        set {
            withPhysicsBody({ $0.mass = newValue }, default: ())
        }
    }

    public var velocity: CGVector {
        get {
            withPhysicsBody({ $0.velocity }, default: DefaultSKPhysicsBodyValues.velocity)
        }
        set {
            withPhysicsBody({ $0.velocity = newValue }, default: ())
        }
    }
    
    public var isDynamic: Bool {
        get {
            withPhysicsBody({ $0.isDynamic }, default: DefaultSKPhysicsBodyValues.isDynamic)
        }
        set {
            withPhysicsBody({ $0.isDynamic = newValue }, default: ())
        }
    }
    
    public var affectedByGravity: Bool {
        get {
            withPhysicsBody({ $0.affectedByGravity }, default: DefaultSKPhysicsBodyValues.affectedByGravity)
        }
        set {
            withPhysicsBody({ $0.affectedByGravity = newValue }, default: ())
        }
    }

    public var linearDamping: CGFloat {
        get {
            withPhysicsBody({ $0.linearDamping }, default: DefaultSKPhysicsBodyValues.linearDamping)
        }
        set {
            withPhysicsBody({ $0.linearDamping = newValue }, default: ())
        }
    }

    public var allowsRotation: Bool {
        get {
            withPhysicsBody({ $0.allowsRotation }, default: DefaultSKPhysicsBodyValues.allowsRotation)
        }
        set {
            withPhysicsBody({ $0.allowsRotation = newValue }, default: ())
        }
    }
    
    public var friction: CGFloat {
        get {
            withPhysicsBody({ $0.friction }, default: DefaultSKPhysicsBodyValues.friction)
        }
        set {
            withPhysicsBody({ $0.friction = newValue }, default: ())
        }
    }

    public var restitution: CGFloat {
        get {
            withPhysicsBody({ $0.restitution }, default: DefaultSKPhysicsBodyValues.restitution)
        }
        set {
            withPhysicsBody({ $0.restitution = newValue }, default: ())
        }
    }

    public var categoryBitMask: UInt32 {
        get {
            withPhysicsBody({ $0.categoryBitMask }, default: DefaultSKPhysicsBodyValues.categoryBitMask)
        }
        set {
            withPhysicsBody({ $0.categoryBitMask = newValue }, default: ())
        }
    }

    public var collisionBitMask: UInt32 {
        get {
            withPhysicsBody({ $0.collisionBitMask }, default: DefaultSKPhysicsBodyValues.collisionBitMask)
        }
        set {
            withPhysicsBody({ $0.collisionBitMask = newValue }, default: ())
        }
    }

    public var contactTestBitMask: UInt32 {
        get {
            withPhysicsBody({ $0.contactTestBitMask }, default: DefaultSKPhysicsBodyValues.contactTestBitMask)
        }
        set {
            withPhysicsBody({ $0.contactTestBitMask = newValue }, default: ())
        }
    }

    func applyImpulse(_ impulse: CGVector) {
        withPhysicsBody({ $0.applyImpulse(impulse) }, default: ())
    }

    func applyAngularImpulse(_ impulse: CGFloat) {
        withPhysicsBody({ $0.applyAngularImpulse(impulse) }, default: ())
    }
}

extension ArkSKPhysicsBody: Hashable {
    static func == (lhs: ArkSKPhysicsBody, rhs: ArkSKPhysicsBody) -> Bool {
        return lhs.node == rhs.node
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(node)
    }
}
