import SpriteKit

/// Creates and exports a default ArkSKPhysicsBody with default values
struct DefaultSKPhysicsBodyValues {
    static let position: CGPoint = .zero
    static let zRotation: CGFloat = .zero
    static let mass: CGFloat = .zero
    static let velocity: CGVector = .zero
    static let affectedByGravity = true
    static let linearDamping: CGFloat = 0.1
    static let angularDamping: CGFloat = 0.1
    static let isDynamic = true
    static let allowsRotation = true
    static let restitution: CGFloat = .zero
    static let friction: CGFloat = .zero
    static let categoryBitMask: UInt32 = 0xFFFFFFFF
    static let collisionBitMask: UInt32 = 0xFFFFFFFF
    static let contactTestBitMask: UInt32 = 0x00000000
}
