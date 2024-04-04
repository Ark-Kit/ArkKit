import Foundation

/**
 *  A system which updates all running animation instances in ArkECS after the given delta.
 */
class ArkPhysicsSystem: UpdateSystem {
    var active: Bool
    var simulator: AbstractPhysicsArkSimulator
    var scene: AbstractArkPhysicsScene?
    var eventManager: ArkEventManager
    var arkECS: ArkECS
    weak var sceneUpdateDelegate: ArkPhysicsContactUpdateDelegate?

    init(simulator: AbstractPhysicsArkSimulator,
         eventManager: ArkEventManager,
         arkECS: ArkECS,
         active: Bool = true) {
        self.active = active
        self.simulator = simulator
        self.scene = simulator.physicsScene
        self.eventManager = eventManager
        self.arkECS = arkECS
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        let physicsComponents = getPhysicsComponents(arkECS)
        syncToPhysicsEngine(physicsComponents, arkECS: arkECS)
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

    func syncToPhysicsEngine(_ physicsComponents: [(Entity, PhysicsComponent)], arkECS: ArkECS) {
        for (entity, physics) in physicsComponents {
            handlePhysicsComponentRemovalIfNeeded(for: entity, using: physics, arkECS: arkECS)

            guard !physics.toBeRemoved else {
                continue }

            guard let positionComponent = arkECS.getComponent(ofType: PositionComponent.self, for: entity),
                    let rotationComponent = arkECS.getComponent(ofType: RotationComponent.self, for: entity) else {
                continue }

            syncPhysicsBody(for: entity,
                            position: positionComponent,
                            rotation: rotationComponent,
                            physics: physics,
                            arkECS: arkECS)
        }
    }

    private func handlePhysicsComponentRemovalIfNeeded(for entity: Entity,
                                                       using physics: PhysicsComponent,
                                                       arkECS: ArkECS) {
        guard physics.toBeRemoved else {
            return }

        scene?.removePhysicsBody(for: entity)
        arkECS.removeEntity(entity)
    }

    private func syncPhysicsBody(for entity: Entity, position: PositionComponent,
                                 rotation: RotationComponent, physics: PhysicsComponent, arkECS: ArkECS) {
        if var physicsBody = scene?.getPhysicsBody(for: entity) {
            updatePhysicsBody(&physicsBody, position: position, rotation: rotation, physics: physics)
        } else {
            createPhysicsBody(for: entity, positionComponent: position,
                              rotationComponent: rotation, physicsComponent: physics)
        }

        applyPhysicsImpulses(for: entity, with: physics, arkECS: arkECS)
    }

    private func applyPhysicsImpulses(for entity: Entity, with physics: PhysicsComponent, arkECS: ArkECS) {
        if physics.impulse != .zero {
            scene?.apply(impulse: physics.impulse, to: entity)
            apply(impulse: .zero, to: entity, arkECS: arkECS)
        }
        if physics.angularImpulse != .zero {
            scene?.apply(angularImpulse: physics.angularImpulse, to: entity)
            apply(angularImpulse: .zero, to: entity, arkECS: arkECS)
        }
    }

    private func createPhysicsBody(for entity: Entity,
                                   positionComponent: PositionComponent,
                                   rotationComponent: RotationComponent,
                                   physicsComponent: PhysicsComponent) {
        var physicsBody: AbstractArkPhysicsBody?
        if physicsComponent.shape == .circle, let radius = physicsComponent.radius {
            physicsBody = scene?.createCirclePhysicsBody(for: entity,
                                                         withRadius: radius,
                                                         at: positionComponent.position)
        } else if physicsComponent.shape == .rectangle, let size = physicsComponent.size {
            physicsBody = scene?.createRectanglePhysicsBody(for: entity,
                                                            withSize: size,
                                                            at: positionComponent.position)
        }

        if var physicsBody = physicsBody {
            updatePhysicsBody(&physicsBody, position: positionComponent,
                              rotation: rotationComponent, physics: physicsComponent)
        }
    }

    private func updatePhysicsBody(_ physicsBody: inout AbstractArkPhysicsBody,
                                   position: PositionComponent,
                                   rotation: RotationComponent,
                                   physics: PhysicsComponent) {
        physicsBody.position = position.position
        physicsBody.zRotation = rotation.angleInRadians ?? physicsBody.zRotation
        updateOptionalPhysicsBodyProperties(&physicsBody, with: physics)
    }

    private func updateOptionalPhysicsBodyProperties(_ physicsBody: inout AbstractArkPhysicsBody,
                                                     with physicsComponent: PhysicsComponent) {
        physicsBody.mass = physicsComponent.mass ?? physicsBody.mass
        physicsBody.velocity = physicsComponent.velocity
        physicsBody.affectedByGravity = physicsComponent.affectedByGravity
        physicsBody.linearDamping = physicsComponent.linearDamping
        physicsBody.isDynamic = physicsComponent.isDynamic
        physicsBody.allowsRotation = physicsComponent.allowsRotation
        physicsBody.restitution = physicsComponent.restitution
        physicsBody.friction = physicsComponent.friction
        physicsBody.categoryBitMask = physicsComponent.categoryBitMask
        physicsBody.collisionBitMask = physicsComponent.collisionBitMask
        physicsBody.contactTestBitMask = physicsComponent.contactTestBitMask
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
        var arkCollisionEvent = makeCollisionEvent(ArkCollisionBeganEvent.self, entityA, entityB)
        self.eventManager.emit(arkCollisionEvent)
    }

    func handleCollisionEnd(between entityA: Entity, and entityB: Entity) {
        var arkCollisionEvent = makeCollisionEvent(ArkCollisionEndedEvent.self, entityA, entityB)
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

extension ArkPhysicsSystem: ArkPhysicsContactUpdateDelegate {
    func didContactBegin(between entityA: Entity, and entityB: Entity) {
        handleCollisionBegan(between: entityA, and: entityB)
    }

    func didContactEnd(between entityA: Entity, and entityB: Entity) {
        handleCollisionEnd(between: entityA, and: entityB)
    }
}

extension ArkPhysicsSystem: ArkPhysicsSceneUpdateLoopDelegate {
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
        guard let positionComponent: PositionComponent =
                arkECS.getComponent(ofType: PositionComponent.self, for: entity) else {
            return }
        var newPositionComp = positionComponent
        newPositionComp.position = physicsBody.position
        arkECS.upsertComponent(newPositionComp, to: entity)
    }
}

struct RotationComponentSync: ComponentSyncing {
    func sync(entity: Entity, with physicsBody: AbstractArkPhysicsBody, using arkECS: ArkECS) {
        guard var rotationComponent: RotationComponent =
                arkECS.getComponent(ofType: RotationComponent.self, for: entity) else {
            return }
        rotationComponent.angleInRadians = physicsBody.zRotation
        arkECS.upsertComponent(rotationComponent, to: entity)
    }
}
