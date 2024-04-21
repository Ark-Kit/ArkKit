import SpriteKit

class SKPhysicsBodyManager {
    private(set) var entityToPhysicsBodyMap: [Entity: any AbstractArkSKPhysicsBody] = [:]
    private var nodeToEntityMap: [SKNode: Entity] = [:]

    func addBody(for entity: Entity, body: any AbstractArkSKPhysicsBody) -> Bool {
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
            return
        }
        nodeToEntityMap.removeValue(forKey: body.node)
    }

    func getBody(for entity: Entity) -> (any AbstractArkSKPhysicsBody)? {
        entityToPhysicsBodyMap[entity]
    }

    func getEntity(for node: SKNode) -> Entity? {
        nodeToEntityMap[node]
    }

    @discardableResult
    func applyImpulse(_ impulse: CGVector, to entity: Entity) -> Bool {
        guard let body = entityToPhysicsBodyMap[entity] else {
            return false
        }
        body.applyImpulse(impulse)
        return true
    }

    @discardableResult
    func applyAngularImpulse(_ angularImpulse: CGFloat, to entity: Entity) -> Bool {
        guard let body = entityToPhysicsBodyMap[entity] else {
            return false
        }
        body.applyAngularImpulse(angularImpulse)
        return true
    }
}
