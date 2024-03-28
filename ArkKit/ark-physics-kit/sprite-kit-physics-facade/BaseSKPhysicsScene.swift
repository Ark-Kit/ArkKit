import SpriteKit

class BaseSKPhysicsScene: SKScene {
    weak var gameScene: SKPhysicsScene?
    weak var sceneContactUpdateDelegate: ArkPhysicsContactUpdateDelegate?
    weak var sceneUpdateLoopDelegate: ArkPhysicsSceneUpdateLoopDelegate?

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

extension BaseSKPhysicsScene: SKPhysicsContactDelegate {
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
