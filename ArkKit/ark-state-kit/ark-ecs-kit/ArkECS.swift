import Foundation

class ArkECS {
    private let entityManager: EntityManager
    private let systemManager: SystemManager

    init() {
        self.entityManager = EntityManager()
        self.systemManager = SystemManager()
    }

    func startUp() {
        self.systemManager.startUp()
    }

    func update(deltaTime: TimeInterval) {
        systemManager.update(deltaTime: deltaTime, arkECS: self)
    }

    func cleanUp() {
        self.systemManager.cleanUp()
    }
}

extension ArkECS: ArkECSContext {

    @discardableResult
    func createEntity() -> Entity {
        entityManager.createEntity()
    }

    func removeEntity(_ entity: Entity) {
        entityManager.removeEntity(entity)
    }

    func upsertComponent<T>(_ component: T, to entity: Entity) where T: Component {
        entityManager.upsertComponent(component, to: entity)
    }

    func removeComponent<T>(ofType type: T.Type, from entity: Entity) where T: Component {
        entityManager.removeComponent(ofType: type, from: entity)
    }

    func getComponent<T>(ofType type: T.Type, for entity: Entity) -> T? where T: Component {
        entityManager.getComponent(ofType: type, for: entity)
    }

    @discardableResult
    func createEntity(with components: [any Component]) -> Entity {
        entityManager.createEntity(with: components)
    }

    func getEntity(id: EntityID) -> Entity? {
        entityManager.getEntity(id: id)
    }

    func getEntities(with componentTypes: [any Component.Type]) -> [Entity] {
        entityManager.getEntities(with: componentTypes)
    }

    func getComponents(from entity: Entity) -> [any Component] {
        entityManager.getComponents(from: entity)
    }

    func addSystem(_ system: UpdateSystem, schedule: Schedule = .update, isUnique: Bool = true) {
        systemManager.add(system, schedule: schedule, isUnique: isUnique)
    }
}
