//
//  ArkECS.swift
//  ArkKit
//
//  Created by Ryan Peh on 11/3/24.
//

import Foundation

typealias ECSSetupFunction = (_: ArkECSContext) -> Void

class ArkECS {
    private let entityManager: EntityManager
    private let systemManager: SystemManager

    init() {
        self.entityManager = EntityManager()
        self.systemManager = SystemManager()
    }

    func update(deltaTime: TimeInterval) {
        systemManager.update(deltaTime: deltaTime, arkECS: self)
    }

    func addSystem(_ system: System) {
        systemManager.add(system)
    }

    func setup(_ setupFunction: ECSSetupFunction) {
        setupFunction(self)
    }
}

extension ArkECS: ArkECSContext {
    func createEntity() -> Entity {
        entityManager.createEntity()
    }

    func removeEntity(_ entity: Entity) {
        entityManager.removeEntity(entity)
    }

    func upsertComponent<T>(_ component: T, to entity: Entity) where T: Component {
        entityManager.upsertComponent(component, to: entity)
    }
    
    func removeComponent<T>(_ componentType: T.Type, from entity: Entity) where T: Component {
        entityManager.removeComponent(ofType: componentType, from: entity)
    }

    func getComponent<T>(ofType type: T.Type, for entity: Entity) -> T? where T: Component {
        entityManager.getComponent(ofType: type, for: entity)
    }

    func createEntity(with components: [any Component]) -> Entity {
        entityManager.createEntity(with: components)
    }

    func getEntities(with componentTypes: [any Component.Type]) -> [Entity] {
        entityManager.getEntities(with: componentTypes)
    }

    func getComponents(from entity: Entity) -> [any Component] {
        entityManager.getComponents(from: entity)
    }
}
