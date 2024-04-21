import SpriteKit

class ArkSKPhysicsBody: AbstractArkSKPhysicsBody {
    private(set) var node: SKNode
    private let nodeNoPhysicsBodyFailureMessage = "SKNode does not contain an associated SKPhysicsBody."
    private let physicsBodyFailedToCreateMessage = "Failed to create an SKPhysicsBody."

    init(rectangleOf size: CGSize, at position: CGPoint = .zero) {
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        node = SKNode()
        node.position = position
        node.physicsBody = physicsBody
    }

    init(circleOf radius: CGFloat, at position: CGPoint = .zero) {
        let physicsBody = SKPhysicsBody(circleOfRadius: radius)
        node = SKNode()
        node.position = position
        node.physicsBody = physicsBody
    }

    init(polygonOf vertices: [CGPoint], at position: CGPoint = .zero) {
        guard vertices.count >= 3 else {
            self.node = SKNode()
            assertionFailure(physicsBodyFailedToCreateMessage)
            return
        }

        node = SKNode()
        node.position = position

        let cgPath = CGMutablePath()
        cgPath.addLines(between: vertices)
        cgPath.closeSubpath()

        let physicsBody = SKPhysicsBody(polygonFrom: cgPath)
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

    var mass: CGFloat {
        get {
            withPhysicsBody({ $0.mass }, default: DefaultSKPhysicsBodyValues.mass)
        }
        set {
            withPhysicsBody({ $0.mass = newValue }, default: ())
        }
    }

    var velocity: CGVector {
        get {
            withPhysicsBody({ $0.velocity }, default: DefaultSKPhysicsBodyValues.velocity)
        }
        set {
            withPhysicsBody({ $0.velocity = newValue }, default: ())
        }
    }

    var isDynamic: Bool {
        get {
            withPhysicsBody({ $0.isDynamic }, default: DefaultSKPhysicsBodyValues.isDynamic)
        }
        set {
            withPhysicsBody({ $0.isDynamic = newValue }, default: ())
        }
    }

    var affectedByGravity: Bool {
        get {
            withPhysicsBody({ $0.affectedByGravity }, default: DefaultSKPhysicsBodyValues.affectedByGravity)
        }
        set {
            withPhysicsBody({ $0.affectedByGravity = newValue }, default: ())
        }
    }

    var linearDamping: CGFloat {
        get {
            withPhysicsBody({ $0.linearDamping }, default: DefaultSKPhysicsBodyValues.linearDamping)
        }
        set {
            withPhysicsBody({ $0.linearDamping = newValue }, default: ())
        }
    }

    var angularDamping: CGFloat {
        get {
            withPhysicsBody({ $0.angularDamping }, default: DefaultSKPhysicsBodyValues.angularDamping)
        }
        set {
            withPhysicsBody({ $0.angularDamping = newValue }, default: ())
        }
    }

    var allowsRotation: Bool {
        get {
            withPhysicsBody({ $0.allowsRotation }, default: DefaultSKPhysicsBodyValues.allowsRotation)
        }
        set {
            withPhysicsBody({ $0.allowsRotation = newValue }, default: ())
        }
    }

    var friction: CGFloat {
        get {
            withPhysicsBody({ $0.friction }, default: DefaultSKPhysicsBodyValues.friction)
        }
        set {
            withPhysicsBody({ $0.friction = newValue }, default: ())
        }
    }

    var restitution: CGFloat {
        get {
            withPhysicsBody({ $0.restitution }, default: DefaultSKPhysicsBodyValues.restitution)
        }
        set {
            withPhysicsBody({ $0.restitution = newValue }, default: ())
        }
    }

    var categoryBitMask: UInt32 {
        get {
            withPhysicsBody({ $0.categoryBitMask }, default: DefaultSKPhysicsBodyValues.categoryBitMask)
        }
        set {
            withPhysicsBody({ $0.categoryBitMask = newValue }, default: ())
        }
    }

    var collisionBitMask: UInt32 {
        get {
            withPhysicsBody({ $0.collisionBitMask }, default: DefaultSKPhysicsBodyValues.collisionBitMask)
        }
        set {
            withPhysicsBody({ $0.collisionBitMask = newValue }, default: ())
        }
    }

    var contactTestBitMask: UInt32 {
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
        lhs.node == rhs.node
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(node)
    }
}
