import Foundation

/**
 *  A system which syncs from the physics world.
 */
class ArkPhysicsSyncSystem: UpdateSystem {
    var active: Bool
    var scene: AbstractArkPhysicsScene?
    var eventManager: ArkEventManager
    var arkECS: ArkECS
    weak var sceneUpdateDelegate: ArkPhysicsContactUpdateDelegate?

    init(simulator: AbstractPhysicsArkSimulator,
         eventManager: ArkEventManager,
         arkECS: ArkECS,
         active: Bool = true) {
        self.active = active
        self.scene = simulator.physicsScene
        self.eventManager = eventManager
        self.arkECS = arkECS
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
    }

    private func getPhysicsComponents(_ arkECS: ArkECS) -> [(Entity, PhysicsComponent)] {
        arkECS.getEntities(with: [PhysicsComponent.self]).compactMap { entity in
            guard let physicsComponent = arkECS.getComponent(ofType: PhysicsComponent.self, for: entity) else {
                return nil
            }
            return (entity, physicsComponent)
        }
    }

    func syncFromPhysicsEngine() {
        let syncStrategies: [ComponentSyncing] = [PhysicsComponentSync(),
                                                  PositionComponentSync(),
                                                  RotationComponentSync()]

        scene?.forEachEntity(perform: { entity, physicsBody in
            syncStrategies.forEach { strategy in
                strategy.sync(entity: entity, with: physicsBody, using: self.arkECS)
            }
        })
    }

    // MARK: Impulse application
    func apply(impulse: CGVector, to entity: Entity, arkECS: ArkECS) {
        guard var physicsComponent: PhysicsComponent =
            arkECS.getComponent(ofType: PhysicsComponent.self, for: entity) else {
        return
        }
        physicsComponent.impulse = impulse
        arkECS.upsertComponent(physicsComponent, to: entity)
    }

    func apply(angularImpulse: CGFloat, to entity: Entity, arkECS: ArkECS) {
        guard var physicsComponent: PhysicsComponent =
            arkECS.getComponent(ofType: PhysicsComponent.self, for: entity) else {
        return
        }
        physicsComponent.angularImpulse = angularImpulse
        arkECS.upsertComponent(physicsComponent, to: entity)
    }

    // MARK: Handle Collision
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity) {
        let arkCollisionEvent = makeCollisionEvent(ArkCollisionBeganEvent.self, entityA, entityB)
        self.eventManager.emit(arkCollisionEvent)
    }

    func handleCollisionEnd(between entityA: Entity, and entityB: Entity) {
        let arkCollisionEvent = makeCollisionEvent(ArkCollisionEndedEvent.self, entityA, entityB)
        self.eventManager.emit(arkCollisionEvent)
    }

    private func makeCollisionEvent<T: ArkCollisionEventProtocol> (_ eventType: T.Type,
                                                                   _ entityA: Entity,
                                                                   _ entityB: Entity) -> T {
        let entityACategoryBitMask = scene?.getPhysicsBody(for: entityA)?.categoryBitMask ?? 0
        let entityBCategoryBitMask = scene?.getPhysicsBody(for: entityB)?.categoryBitMask ?? 0
        let arkCollisionEvent = T(eventData: ArkCollisionEventData(
            entityA: entityA,
            entityACategoryBitMask: entityACategoryBitMask,
            entityB: entityB,
            entityBCategoryBitMask: entityBCategoryBitMask),
                                  priority: 0)
        return arkCollisionEvent
    }
}

extension ArkPhysicsSyncSystem: ArkPhysicsContactUpdateDelegate {
    func didContactBegin(between entityA: Entity, and entityB: Entity) {
        handleCollisionBegan(between: entityA, and: entityB)
    }

    func didContactEnd(between entityA: Entity, and entityB: Entity) {
        handleCollisionEnd(between: entityA, and: entityB)
    }
}

extension ArkPhysicsSyncSystem: ArkPhysicsSceneUpdateLoopDelegate {
    func update(_ deltaTime: TimeInterval) {
        syncFromPhysicsEngine()
    }
}

protocol ArkCollisionEventProtocol: ArkEvent {
    init(eventData: ArkCollisionEventData, priority: Int?)
}

struct ArkCollisionEventData: ArkEventData {
    var name = ""
    var entityA: Entity
    var entityACategoryBitMask: UInt32
    var entityB: Entity
    var entityBCategoryBitMask: UInt32
}

struct ArkCollisionEndedEvent: ArkCollisionEventProtocol {
    static var id = UUID()
    var eventData: ArkCollisionEventData
    var priority: Int?

    init(eventData: ArkCollisionEventData, priority: Int? = 10) {
        self.eventData = eventData
    }
}

struct ArkCollisionBeganEvent: ArkCollisionEventProtocol {
    static var id = UUID()
    var eventData: ArkCollisionEventData
    var priority: Int?

    init(eventData: ArkCollisionEventData, priority: Int? = 10) {
        self.eventData = eventData
        self.priority = priority
    }
}

protocol ComponentSyncing {
    func sync(entity: Entity, with physicsBody: AbstractArkPhysicsBody, using arkECS: ArkECS)
}

struct PhysicsComponentSync: ComponentSyncing {
    func sync(entity: Entity, with physicsBody: AbstractArkPhysicsBody, using arkECS: ArkECS) {
        guard var physicsComponent: PhysicsComponent =
                arkECS.getComponent(ofType: PhysicsComponent.self, for: entity) else {
            return }
        physicsComponent.velocity = physicsBody.velocity
        physicsComponent.mass = physicsBody.mass
        physicsComponent.affectedByGravity = physicsBody.affectedByGravity
        physicsComponent.linearDamping = physicsBody.linearDamping
        physicsComponent.isDynamic = physicsBody.isDynamic
        physicsComponent.allowsRotation = physicsBody.allowsRotation
        physicsComponent.restitution = physicsBody.restitution
        physicsComponent.friction = physicsBody.friction

        physicsComponent.categoryBitMask = physicsBody.categoryBitMask
        physicsComponent.contactTestBitMask = physicsBody.contactTestBitMask
        physicsComponent.collisionBitMask = physicsBody.collisionBitMask
        arkECS.upsertComponent(physicsComponent, to: entity)
    }
}

struct PositionComponentSync: ComponentSyncing {
    func sync(entity: Entity, with physicsBody: AbstractArkPhysicsBody, using arkECS: ArkECS) {
        let newPositionComp = PositionComponent(position: physicsBody.position)
        arkECS.upsertComponent(newPositionComp, to: entity)
    }
}

struct RotationComponentSync: ComponentSyncing {
    func sync(entity: Entity, with physicsBody: AbstractArkPhysicsBody, using arkECS: ArkECS) {
        let rotationComponent = RotationComponent(angleInRadians: physicsBody.zRotation)
        arkECS.upsertComponent(rotationComponent, to: entity)
    }
}
