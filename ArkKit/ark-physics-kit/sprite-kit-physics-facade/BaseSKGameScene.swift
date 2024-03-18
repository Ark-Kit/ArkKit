import SpriteKit

class BaseSKGameScene: SKScene {
    weak var gameScene: SKGameScene?
    weak var sceneUpdateDelegate: ArkSceneUpdateDelegate?

    override func sceneDidLoad() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.81)
        physicsWorld.contactDelegate = self
    }
    
    override func didFinishUpdate() {
    }
}

extension BaseSKGameScene: SKSceneDelegate {
    func didFinishUpdate(for scene: SKScene) {
    }
}

extension BaseSKGameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let entityA = gameScene?.getEntity(for: contact.bodyA),
              let entityB = gameScene?.getEntity(for: contact.bodyB) else {
            return
        }
        sceneUpdateDelegate?.didContactBegin(between: entityA, and: entityB)
    }

    func didEnd(_ contact: SKPhysicsContact) {
        guard let entityA = gameScene?.getEntity(for: contact.bodyA),
              let entityB = gameScene?.getEntity(for: contact.bodyB) else {
            return
        }
        sceneUpdateDelegate?.didContactEnd(between: entityA, and: entityB)
    }
}
