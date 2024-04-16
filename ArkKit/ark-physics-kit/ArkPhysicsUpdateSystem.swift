import Foundation

/**
 *  A system which updates all running physics instances in ArkECS after the given delta.
 */
class ArkPhysicsUpdateSystem: UpdateSystem {
    var active: Bool
    var scene: AbstractArkPhysicsScene?
    var eventManager: ArkEventManager
    var arkECS: ArkECS

    var creators: [ArkPhysicsShape: PhysicsBodyCreator] = [
        .circle: CirclePhysicsBodyCreator(),
        .rectangle: RectanglePhysicsBodyCreator(),
        .polygon: PolygonPhysicsBodyCreator()
    ]

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
        syncToPhysicsEngine(arkECS: arkECS)
    }

    private func getPhysicsComponents(_ arkECS: ArkECS) -> [(Entity, PhysicsComponent)] {
        arkECS.getEntities(with: [PhysicsComponent.self]).compactMap { entity in
            guard let physicsComponent = arkECS.getComponent(ofType: PhysicsComponent.self, for: entity) else {
                return nil
            }
            return (entity, physicsComponent)
        }
    }

    func syncToPhysicsEngine(arkECS: ArkECS) {
        let physicsComponents = getPhysicsComponents(arkECS)
        for (entity, physics) in physicsComponents {

            if arkECS.getComponent(ofType: ToRemoveComponent.self, for: entity) != nil {
                return }

            guard let positionComponent = arkECS.getComponent(ofType: PositionComponent.self, for: entity),
                    let rotationComponent = arkECS.getComponent(ofType: RotationComponent.self, for: entity) else {
                continue }

            syncPhysicsBody(for: entity,
                            position: positionComponent,
                            rotation: rotationComponent,
                            physics: physics,
                            arkECS: arkECS)
        }
        let gravityEntities = arkECS.getEntities(with: [GravityComponent.self])
        for entity in gravityEntities {
            guard let gravity = arkECS.getComponent(ofType: GravityComponent.self, for: entity) else {
                continue }
            updateGravity(gravity.gravityVector)
            gravity.markForRemoval(entity: entity, ecs: arkECS)
        }
    }

    func updateGravity(_ gravity: CGVector) {
        scene?.setGravity(gravity)
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
        guard let creator = creators[physicsComponent.shape] else {
            return }
        let position = positionComponent.position
        if let scene = scene,
           var physicsBody = creator.createPhysicsBody(for: entity, with: physicsComponent,
                                                       at: position, scene: scene) {
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
}

extension ArkPhysicsUpdateSystem: ArkPhysicsRemovalDelegate {
    func removePhysicsBody(for entity: Entity) {
        scene?.removePhysicsBody(for: entity)
    }
}

protocol ArkPhysicsRemovalDelegate {
    func removePhysicsBody(for entity: Entity)
}

protocol PhysicsBodyCreator {
    func createPhysicsBody(for entity: Entity, with component: PhysicsComponent,
                           at position: CGPoint, scene: AbstractArkPhysicsScene) -> AbstractArkPhysicsBody?
}

struct CirclePhysicsBodyCreator: PhysicsBodyCreator {
    func createPhysicsBody(for entity: Entity, with component: PhysicsComponent,
                           at position: CGPoint, scene: AbstractArkPhysicsScene) -> AbstractArkPhysicsBody? {
        guard let radius = component.radius else {
            return nil }
        return scene.createCirclePhysicsBody(for: entity, withRadius: radius, at: position)
    }
}

struct RectanglePhysicsBodyCreator: PhysicsBodyCreator {
    func createPhysicsBody(for entity: Entity, with component: PhysicsComponent,
                           at position: CGPoint, scene: AbstractArkPhysicsScene) -> AbstractArkPhysicsBody? {
        guard let size = component.size else {
            return nil }
        return scene.createRectanglePhysicsBody(for: entity, withSize: size, at: position)
    }
}

struct PolygonPhysicsBodyCreator: PhysicsBodyCreator {
    func createPhysicsBody(for entity: Entity, with component: PhysicsComponent,
                           at position: CGPoint, scene: AbstractArkPhysicsScene) -> AbstractArkPhysicsBody? {
        guard let vertices = component.vertices else {
            return nil }
        return scene.createPolygonPhysicsBody(for: entity, withVertices: vertices, at: position)
    }
}
