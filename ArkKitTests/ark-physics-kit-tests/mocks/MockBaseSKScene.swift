import SpriteKit
@testable import ArkKit

class MockBaseSKScene: AbstractSKScene {
    override init(size: CGSize) {
        super.init(size: size)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.81)
        self.physicsWorld.contactDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        sceneUpdateLoopDelegate?.update(deltaTime)
    }
}

extension MockBaseSKScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let entityA = gameScene?.getEntity(for: contact.bodyA),
              let entityB = gameScene?.getEntity(for: contact.bodyB) else {
            return
        }
        sceneContactUpdateDelegate?.didContactBegin(between: entityA, and: entityB)
    }

    func didEnd(_ contact: SKPhysicsContact) {
        guard let entityA = gameScene?.getEntity(for: contact.bodyA),
              let entityB = gameScene?.getEntity(for: contact.bodyB) else {
            return
        }
        sceneContactUpdateDelegate?.didContactEnd(between: entityA, and: entityB)
    }
}
