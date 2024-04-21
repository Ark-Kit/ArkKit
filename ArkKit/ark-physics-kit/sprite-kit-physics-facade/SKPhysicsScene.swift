import SpriteKit

class SKPhysicsScene: AbstractArkPhysicsScene {
    private(set) var basePhysicsScene: AbstractSKScene
    private var physicsBodyManager: SKPhysicsBodyManager
    private var physicsBodyFactory: AbstractArkSKPhysicsBodyFactory

    init(size: CGSize, delegate: SKSceneDelegate? = nil,
         basePhysicsScene: AbstractSKScene? = nil,
         physicsBodyManager: SKPhysicsBodyManager? = nil,
         gameScene: SKPhysicsScene? = nil,
         physicsBodyFactory: AbstractArkSKPhysicsBodyFactory? = nil) {
        self.basePhysicsScene = basePhysicsScene ?? BaseSKScene(size: size)
        self.basePhysicsScene.delegate = delegate
        self.physicsBodyManager = physicsBodyManager ?? SKPhysicsBodyManager()
        self.physicsBodyFactory = physicsBodyFactory ?? ArkSKPhysicsBodyFactory()
        self.basePhysicsScene.gameScene = gameScene ?? self
    }

    func getCurrentTime() -> TimeInterval {
        basePhysicsScene.currentTime
    }

    func setGravity(_ gravity: CGVector) {
        basePhysicsScene.physicsWorld.gravity = gravity
    }

    var sceneContactUpdateDelegate: ArkPhysicsContactUpdateDelegate? {
        get { basePhysicsScene.sceneContactUpdateDelegate }
        set { basePhysicsScene.sceneContactUpdateDelegate = newValue }
    }

    var sceneUpdateLoopDelegate: ArkPhysicsSceneUpdateLoopDelegate? {
        get { basePhysicsScene.sceneUpdateLoopDelegate }
        set { basePhysicsScene.sceneUpdateLoopDelegate = newValue }
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
        let newPhysicsBody = physicsBodyFactory.createCirclePhysicsBody(for: entity, radius: radius, at: position)
        addBody(for: entity, bodyToAdd: newPhysicsBody)
        return newPhysicsBody
    }

    func createRectanglePhysicsBody(for entity: Entity,
                                    withSize size: CGSize,
                                    at position: CGPoint) -> AbstractArkPhysicsBody {
        let newPhysicsBody = physicsBodyFactory.createRectanglePhysicsBody(for: entity, size: size, at: position)
        addBody(for: entity, bodyToAdd: newPhysicsBody)
        return newPhysicsBody
    }

    func createPolygonPhysicsBody(for entity: Entity,
                                  withVertices vertices: [CGPoint],
                                  at position: CGPoint) -> any AbstractArkPhysicsBody {
        let newPhysicsBody = physicsBodyFactory.createPolygonPhysicsBody(for: entity, vertices: vertices, at: position)
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

    func addBody(for entity: Entity, bodyToAdd: any AbstractArkSKPhysicsBody) {
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
