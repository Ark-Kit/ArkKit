import SpriteKit

class SKGameScene: AbstractArkGameScene {
    func getCurrentTime() -> TimeInterval {
        baseGameScene.currentTime
    }

    private(set) var baseGameScene: BaseSKGameScene
    private var physicsBodyManager: SKPhysicsBodyManager

    var sceneUpdateDelegate: ArkSceneUpdateDelegate? {
        get { baseGameScene.sceneUpdateDelegate }
        set { baseGameScene.sceneUpdateDelegate = newValue }
    }

    init(size: CGSize) {
        self.baseGameScene = BaseSKGameScene(size: size)
        self.baseGameScene.delegate = self.baseGameScene
        self.physicsBodyManager = SKPhysicsBodyManager()
        self.baseGameScene.gameScene = self
    }

    func getDeltaTime() -> TimeInterval {
        baseGameScene.deltaTime
    }

    func forEachEntity(perform action: (Entity, AbstractArkPhysicsBody) -> Void) {
        for (entity, physicsBody) in physicsBodyManager.entityToPhysicsBodyMap {
                action(entity, physicsBody)
        }
    }

    func createCirclePhysicsBody(for entity: Entity,
                                 withRadius radius: CGFloat,
                                 at position: CGPoint) -> AbstractArkPhysicsBody {
        let newPhysicsBody = ArkSKPhysicsBody(circleOf: radius, at: position)
        addBody(for: entity, bodyToAdd: newPhysicsBody)
        return newPhysicsBody
    }

    func createRectanglePhysicsBody(for entity: Entity,
                                    withSize size: CGSize,
                                    at position: CGPoint) -> AbstractArkPhysicsBody {
        let newPhysicsBody = ArkSKPhysicsBody(rectangleOf: size, at: position)
        addBody(for: entity, bodyToAdd: newPhysicsBody)
        return newPhysicsBody
    }

    func getPhysicsBody(for entity: Entity) -> (any AbstractArkPhysicsBody)? {
        physicsBodyManager.getBody(for: entity)
    }

    func removePhysicsBody(for entity: Entity) {
        if let physicsBody = physicsBodyManager.getBody(for: entity) {
            baseGameScene.removeChildren(in: [physicsBody.node])
        }
        physicsBodyManager.removeBody(for: entity)
    }

    func apply(impulse: CGVector, to entity: Entity) {
        physicsBodyManager.applyImpulse(impulse, to: entity)
    }

    func apply(angularImpulse: CGFloat, to entity: Entity) {
        physicsBodyManager.applyAngularImpulse(angularImpulse, to: entity)
    }

    func addBody(for entity: Entity, bodyToAdd: ArkSKPhysicsBody) {
        if physicsBodyManager.addBody(for: entity, body: bodyToAdd) {
            baseGameScene.addChild(bodyToAdd.node)
        }
    }

    func getEntity(for skPhysicsBody: SKPhysicsBody) -> Entity? {
        guard let node = skPhysicsBody.node else {
            return nil
        }
        return physicsBodyManager.getEntity(for: node)
    }
}
