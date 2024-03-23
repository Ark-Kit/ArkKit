//
//  EntityManager.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

class EntityManager {
    private var entities = Set<Entity>()
    private var componentsByType = [ObjectIdentifier: [Entity: Component]]()

    func createEntity() -> Entity {
        let entity = Entity()
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

    func createEntity(with components: [Component]) -> Entity {
        let entity = Entity()
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
        let entitySets = componentTypes.map { compType in
            let identifier = ObjectIdentifier(compType)
            var entitySet = Set<Entity>()
            componentsByType[identifier]?.keys.forEach { entity in
                entitySet.insert(entity)
            }
            return entitySet
        }
        guard let firstSet = entitySets.first else {
            return []
        }
        var commonEntities = firstSet
        for entitySet in entitySets.dropFirst() {
            commonEntities.formIntersection(entitySet)
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
}
