import SpriteKit

class BaseSKGameScene: SKScene {
    weak var gameScene: SKGameScene?
    weak var sceneUpdateDelegate: ArkSceneUpdateDelegate?
    var currentTime: TimeInterval = 0
    private var lastUpdateTime: TimeInterval = 0
    private(set) var deltaTime: TimeInterval = 0

    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if lastUpdateTime.isZero {
            lastUpdateTime = currentTime
        }
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        return deltaTime
    }

    override func sceneDidLoad() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.81)
        physicsWorld.contactDelegate = self
    }

    override func update(_ currentTime: TimeInterval) {
        deltaTime = calculateDeltaTime(from: currentTime)
        self.currentTime += deltaTime
    }
}

extension BaseSKGameScene: SKSceneDelegate {
    func didFinishUpdate(for scene: SKScene) {
        sceneUpdateDelegate?.didFinishUpdate(deltaTime)
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
