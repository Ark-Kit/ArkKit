import SpriteKit

class SKPhysicsScene: AbstractArkPhysicsScene {
    func getCurrentTime() -> TimeInterval {
        basePhysicsScene.currentTime
    }

    private(set) var basePhysicsScene: BaseSKPhysicsScene
    private var physicsBodyManager: SKPhysicsBodyManager

    var sceneContactUpdateDelegate: ArkPhysicsContactUpdateDelegate? {
        get { basePhysicsScene.sceneContactUpdateDelegate }
        set { basePhysicsScene.sceneContactUpdateDelegate = newValue }
    }

    var sceneUpdateLoopDelegate: ArkPhysicsSceneUpdateLoopDelegate? {
        get { basePhysicsScene.sceneUpdateLoopDelegate }
        set { basePhysicsScene.sceneUpdateLoopDelegate = newValue }
    }

    init(size: CGSize, delegate: SKSceneDelegate? = nil) {
        self.basePhysicsScene = BaseSKPhysicsScene(size: size)
        self.basePhysicsScene.delegate = delegate
        self.physicsBodyManager = SKPhysicsBodyManager()
        self.basePhysicsScene.gameScene = self

    }

    func getDeltaTime() -> TimeInterval {
        basePhysicsScene.deltaTime
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
            basePhysicsScene.removeChildren(in: [physicsBody.node])
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
            basePhysicsScene.addChild(bodyToAdd.node)
        }
    }

    func getEntity(for skPhysicsBody: SKPhysicsBody) -> Entity? {
        guard let node = skPhysicsBody.node else {
            return nil
        }
        return physicsBodyManager.getEntity(for: node)
    }
}
