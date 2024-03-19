import SpriteKit

class SKPhysicsBodyManager {
    private(set) var entityToPhysicsBodyMap: [Entity: ArkSKPhysicsBody] = [:]
    private var nodeToEntityMap: [SKNode: Entity] = [:]

    func addBody(for entity: Entity, body: ArkSKPhysicsBody) -> Bool {
        guard entityToPhysicsBodyMap[entity] == nil, nodeToEntityMap[body.node] == nil else {
            assertionFailure("Entity or Node already exists.")
            return false
        }
        entityToPhysicsBodyMap[entity] = body
        nodeToEntityMap[body.node] = entity
        return true
    }

    func removeBody(for entity: Entity) {
        guard let body = entityToPhysicsBodyMap.removeValue(forKey: entity) else {
            assertionFailure("Entity does not exist.")
            return
        }
        nodeToEntityMap.removeValue(forKey: body.node)
    }

    func getBody(for entity: Entity) -> ArkSKPhysicsBody? {
        entityToPhysicsBodyMap[entity]
    }

    func getEntity(for node: SKNode) -> Entity? {
        nodeToEntityMap[node]
    }

    func applyImpulse(_ impulse: CGVector, to entity: Entity) {
        guard let body = entityToPhysicsBodyMap[entity] else {
            assertionFailure("Entity does not exist.")
            return
        }
        body.applyImpulse(impulse)
    }

    func applyAngularImpulse(_ angularImpulse: CGFloat, to entity: Entity) {
        guard let body = entityToPhysicsBodyMap[entity] else {
            assertionFailure("Entity does not exist.")
            return
        }
        body.applyAngularImpulse(angularImpulse)
    }
}
