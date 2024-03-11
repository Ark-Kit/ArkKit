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

    func addComponent<T: Component>(_ component: T, to entity: Entity) {
        let typeID = ObjectIdentifier(T.self)
        componentsByType[typeID, default: [:]][entity] = component
    }

    func getComponent<T: Component>(ofType type: T.Type, for entity: Entity) -> T? {
        let typeID = ObjectIdentifier(type)
        return componentsByType[typeID]?[entity] as? T
    }
}
