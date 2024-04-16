import Foundation

class EntityManager {
    private var entities = Set<Entity>()
    private var componentsByType = [ObjectIdentifier: [Entity: Component]]()
    private var idGenerator = EntityIDGenerator()

    func createEntity(id: EntityID? = nil) -> Entity {
        let entityId = id ?? idGenerator.generate()
        let entity = Entity(id: entityId)

        entities.insert(entity)
        return entity
    }

    func removeEntity(_ entity: Entity) {
        entities.remove(entity)
        for componentType in componentsByType.keys {
            componentsByType[componentType]?.removeValue(forKey: entity)
        }
    }

    func upsertComponent<T: Component>(_ component: T, to entity: Entity) {
        // add entity if entity does not exist
        if !entities.contains(entity) {
            entities.insert(entity)
        }
        let typeID = ObjectIdentifier(T.self)
        componentsByType[typeID, default: [:]][entity] = component
    }

    func removeComponent<T: Component>(ofType type: T.Type, from entity: Entity) {
        let typeID = ObjectIdentifier(type)
        componentsByType[typeID]?.removeValue(forKey: entity)
    }

    func getComponent<T: Component>(ofType type: T.Type, for entity: Entity) -> T? {
        let typeID = ObjectIdentifier(type)
        return componentsByType[typeID]?[entity] as? T
    }

    func createEntity(with components: [Component], id: EntityID? = nil) -> Entity {
        let entityId = id ?? idGenerator.generate()
        let entity = Entity(id: entityId)
        entities.insert(entity)
        for comp in components {
            upsertComponent(comp, to: entity)
        }
        return entity
    }

    func getEntity(id: EntityID) -> Entity? {
        entities.first { $0.id == id }
    }

    func getEntities(with componentTypes: [Component.Type]) -> [Entity] {
        guard !componentTypes.isEmpty else {
            return Array(entities)
        }

        let entitySets = componentTypes.map { compType in
            let identifier = ObjectIdentifier(compType)
            var entitySet = Set<Entity>()
            componentsByType[identifier]?.keys.forEach { entity in
                entitySet.insert(entity)
            }
            return entitySet
        }

        guard !entitySets.isEmpty else {
            return []
        }

        let commonEntities = entitySets.reduce(entitySets[0]) { partialResult, entitySet in
            partialResult.intersection(entitySet)
        }

        return Array(commonEntities)
    }

    func getComponents(from entity: Entity) -> [Component] {
        var result: [Component] = []
        componentsByType.forEach({ _, mapping in
            if let component = mapping[entity] {
                result.append(component)
            }
        })
        return result
    }

    func removeAllEntities() {
        entities = []
        componentsByType = [:]
    }
}
