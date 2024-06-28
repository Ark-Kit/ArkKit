@testable import ArkKit
import Foundation
import SpriteKit

class MockArkSKPhysicsBody: AbstractArkSKPhysicsBody {
    var node: SKNode
    var position = CGPoint.zero
    var zRotation: CGFloat = 0.0
    var mass: CGFloat = 1.0
    var velocity = CGVector.zero
    var isDynamic = true
    var affectedByGravity = false
    var linearDamping: CGFloat = 0.0
    var angularDamping: CGFloat = 0.0
    var allowsRotation = true
    var friction: CGFloat = 0.0
    var restitution: CGFloat = 0.0
    var categoryBitMask: UInt32 = 0
    var collisionBitMask: UInt32 = 0
    var contactTestBitMask: UInt32 = 0

    private let physicsBodyFailedToCreateMessage = "Failed to create an SKPhysicsBody."

    init(circleOf radius: CGFloat, at position: CGPoint = .zero) {
        self.position = position
        let physicsBody = SKPhysicsBody(circleOfRadius: radius)
        node = SKNode()
        node.position = position
        node.physicsBody = physicsBody
    }

    init(rectangleOf size: CGSize, at position: CGPoint = .zero) {
        self.position = position
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        node = SKNode()
        node.position = position
        node.physicsBody = physicsBody
    }

    init(polygonOf vertices: [CGPoint], at position: CGPoint = .zero) {
        self.position = position
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

    init() {
        self.node = SKNode()
    }

    func applyImpulse(_ impulse: CGVector) {
        velocity = impulse
    }

    func applyAngularImpulse(_ impulse: CGFloat) {
        zRotation += impulse
    }
}
