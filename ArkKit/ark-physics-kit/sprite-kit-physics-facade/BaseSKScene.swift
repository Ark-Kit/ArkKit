import SpriteKit

class BaseSKScene: AbstractSKScene {
    override func sceneDidLoad() {
        super.sceneDidLoad()
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.81)
        physicsWorld.contactDelegate = self
    }
}

extension BaseSKScene: SKPhysicsContactDelegate {
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
