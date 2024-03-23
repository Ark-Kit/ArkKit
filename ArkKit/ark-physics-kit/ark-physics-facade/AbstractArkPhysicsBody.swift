import Foundation

protocol AbstractArkPhysicsBody {
    var position: CGPoint { get set }
    var zRotation: CGFloat { get set }
    var mass: CGFloat { get set }
    var velocity: CGVector { get set }
    var isDynamic: Bool { get set }
    var affectedByGravity: Bool { get set }
    var linearDamping: CGFloat { get set }
    var angularDamping: CGFloat { get set }
    var allowsRotation: Bool { get set }
    var friction: CGFloat { get set }
    var restitution: CGFloat { get set }
    var categoryBitMask: UInt32 { get set }
    var collisionBitMask: UInt32 { get set }
    var contactTestBitMask: UInt32 { get set }
}
