import Foundation

/**
 *  A system which updates all running animation instances in ArkECS after the given delta.
 */
class ArkPhysicsSystem: System {
    var active: Bool
    var scene: AbstractArkGameScene
    var eventManager: ArkEventManager

    init(active: Bool = true, gameScene: AbstractArkGameScene, eventManager: ArkEventManager) {
        self.active = active
        self.scene = gameScene
        self.eventManager = eventManager
    }
    
    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        let physicsComponents = getPhysicsComponents(arkECS)
        syncToPhysicsEngine(physicsComponents, arkECS: arkECS)
        scene.update(deltaTime)
        syncFromPhysicsEngine(arkECS: arkECS)
    }
    
    private func setupPhysicsScene(){
        scene.sceneUpdateDelegate = self
    }
    
    private func getPhysicsComponents(_ arkECS: ArkECS) -> [(Entity, PhysicsComponent)] {
        return arkECS.getEntities(with: [PhysicsComponent.self]).compactMap { entity in
            guard let physicsComponent = arkECS.getComponent(ofType: PhysicsComponent.self, for: entity) else {
                return nil
            }
            return (entity, physicsComponent)
        }
    }
    
    func syncFromPhysicsEngine(arkECS: ArkECS) {
        let syncStrategies: [ComponentSyncing] = [PhysicsComponentSync(), PositionComponentSync(), RotationComponentSync()]
        
        scene.forEachEntity(perform: { entityId, physicsBody in
            syncStrategies.forEach { strategy in
                strategy.sync(entityId: entityId, with: physicsBody, using: arkECS)
            }
        })
    }
    
    func syncToPhysicsEngine(_ physicsComponents: [(Entity, PhysicsComponent)], arkECS: ArkECS) {
        for (entity, physics) in physicsComponents {
            handlePhysicsComponentRemovalIfNeeded(for: entity, using: physics, arkECS: arkECS)
            
            if physics.toBeRemoved {
                continue
            }
            
            let position = arkECS.getComponent(ofType: PositionComponent.self, for: entity)
            let rotation = arkECS.getComponent(ofType: RotationComponent.self, for: entity)
            
            guard let positionComponent = position, let rotationComponent = rotation else {
                continue
            }
            
            syncPhysicsBody(for: entity, position: positionComponent, rotation: rotationComponent, physics: physics, arkECS: arkECS)
        }
    }

    private func handlePhysicsComponentRemovalIfNeeded(for entity: Entity, using physics: PhysicsComponent, arkECS: ArkECS) {
        guard physics.toBeRemoved else { return }
        
        scene.removePhysicsBody(for: entity)
        arkECS.removeEntity(entity)
    }

    private func syncPhysicsBody(for entity: Entity, position: PositionComponent,
                                 rotation: RotationComponent, physics: PhysicsComponent, arkECS: ArkECS) {
        if var physicsBody = scene.getPhysicsBody(for: entity) {
            updatePhysicsBody(&physicsBody, position: position, rotation: rotation, physics: physics)
        } else {
            createPhysicsBody(for: entity, positionComponent: position, rotationComponent: rotation, physicsComponent: physics)
        }
        
        applyPhysicsImpulses(for: entity, with: physics, arkECS: arkECS)
    }

    
    private func applyPhysicsImpulses(for entity: Entity, with physics: PhysicsComponent, arkECS: ArkECS) {
        if physics.impulse != .zero {
            scene.apply(impulse: physics.impulse, to: entity)
            apply(impulse: .zero, to: entity, arkECS: arkECS)
        }
        if physics.angularImpulse != .zero {
            scene.apply(angularImpulse: physics.angularImpulse, to: entity)
            apply(angularImpulse: .zero, to: entity, arkECS: arkECS)
        }
    }
    
    private func createPhysicsBody(for entity: Entity,
                                                  positionComponent: PositionComponent,
                                                  rotationComponent: RotationComponent,
                                                  physicsComponent: PhysicsComponent) {
        var physicsBody: AbstractArkPhysicsBody?
        if physicsComponent.shape == .circle, let radius = physicsComponent.radius {
            physicsBody = scene.createCirclePhysicsBody(for: entity,
                                                                              withRadius: radius,
                                                                              at: positionComponent.position)
        } else if physicsComponent.shape == .rectangle, let size = physicsComponent.size {
            physicsBody = scene.createRectanglePhysicsBody(for: entity,
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
    
    private func updateOptionalPhysicsBodyProperties(_ physicsBody: inout AbstractArkPhysicsBody, with physicsComponent: PhysicsComponent) {
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
    func handleCollision(between entityA: Entity, and entityB: Entity) {
        var arkCollisionEvent: ArkEvent = ArkCollisionEvent(eventData: ArkCollisionEventData(name: "collision", entityA: entityA, entityB: entityB))
        self.eventManager.emit(&arkCollisionEvent)
    }
}

extension ArkPhysicsSystem: ArkSceneUpdateDelegate {
    func didContactBegin(between entityA: Entity, and entityB: Entity) {
        handleCollision(between: entityA, and: entityB)
    }
    
    func didContactEnd(between entityA: Entity, and entityB: Entity) {
        // If we need this we can have a handle collision end event
    }
}

struct ArkCollisionEventData: ArkEventData {
    var name: String
    var entityA: Entity
    var entityB: Entity
}

struct ArkCollisionEvent: ArkEvent {

    static var id = UUID()
    var eventData: ArkEventData?
    var timestamp = Date()
    var priority: Int?

    init(eventData: ArkEventData? = nil, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}

protocol ComponentSyncing {
    func sync(entityId: Entity, with physicsBody: AbstractArkPhysicsBody, using arkECS: ArkECS)
}

struct PhysicsComponentSync: ComponentSyncing {
    func sync(entityId: Entity, with physicsBody: AbstractArkPhysicsBody, using arkECS: ArkECS) {
        guard var physicsComponent: PhysicsComponent = arkECS.getComponent(ofType: PhysicsComponent.self, for: entityId) else { return }
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
        arkECS.upsertComponent(physicsComponent, to: entityId)
    }
}

struct PositionComponentSync: ComponentSyncing {
    func sync(entityId: Entity, with physicsBody: AbstractArkPhysicsBody, using arkECS: ArkECS) {
        guard var positionComponent: PositionComponent = arkECS.getComponent(ofType: PositionComponent.self, for: entityId) else { return }
        positionComponent.position = physicsBody.position
        arkECS.upsertComponent(positionComponent, to: entityId)
    }
}

struct RotationComponentSync: ComponentSyncing {
    func sync(entityId: Entity, with physicsBody: AbstractArkPhysicsBody, using arkECS: ArkECS) {
        guard var rotationComponent: RotationComponent = arkECS.getComponent(ofType: RotationComponent.self, for: entityId) else { return }
        rotationComponent.angleInRadians = physicsBody.zRotation
        arkECS.upsertComponent(rotationComponent, to: entityId)
    }
}
