import Foundation

public class ArkECS: ArkECSContext {
    private let entityManager: EntityManager
    private let systemManager: SystemManager

    init() {
        self.entityManager = EntityManager()
        self.systemManager = SystemManager()
    }

    init(entities: [Entity], components: [EntityID: [any Component]]) {
        self.entityManager = EntityManager()
        self.systemManager = SystemManager()
        for entity in entities {
            let components = components[entity.id] ?? []
            _ = entityManager.createEntity(with: components)
        }
    }

    func bulkUpsert(entities: [Entity], components: [EntityID: [any Component]]) {
        for entity in entities {
            let components = components[entity.id] ?? []
            for component in components {
                entityManager.upsertComponent(component, to: entity)
            }
        }
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

    @discardableResult
    public func createEntity() -> Entity {
        entityManager.createEntity()
    }

    @discardableResult
    public func createEntity(id: EntityID) -> Entity {
        entityManager.createEntity(id: id)
    }

    public func removeEntity(_ entity: Entity) {
        entityManager.removeEntity(entity)
    }

    public func removeAllEntities(except entitiesNotToRemove: [Entity] = []) {
        let entities = getEntities()
        let entitiesMarkedNotToRemove = Set(entitiesNotToRemove)
        for entity in entities {
            if entitiesMarkedNotToRemove.contains(entity) {
                continue
            }
            removeEntity(entity)
        }
    }

    public func upsertComponent<T>(_ component: T, to entity: Entity) where T: Component {
        entityManager.upsertComponent(component, to: entity)
    }

    public func removeComponent<T>(ofType type: T.Type, from entity: Entity) where T: Component {
        entityManager.removeComponent(ofType: type, from: entity)
    }

    public func getComponent<T>(ofType type: T.Type, for entity: Entity) -> T? where T: Component {
        entityManager.getComponent(ofType: type, for: entity)
    }

    @discardableResult
    public func createEntity(with components: [any Component]) -> Entity {
        entityManager.createEntity(with: components)
    }

    @discardableResult
    public func createEntity(id: EntityID, with components: [any Component]) -> Entity {
        entityManager.createEntity(with: components, id: id)
    }

    public func getEntity(id: EntityID) -> Entity? {
        entityManager.getEntity(id: id)
    }

    public func getEntities(with componentTypes: [any Component.Type] = []) -> [Entity] {
        entityManager.getEntities(with: componentTypes)
    }

    public func getComponents(from entity: Entity) -> [any Component] {
        entityManager.getComponents(from: entity)
    }

    func addSystem(_ system: UpdateSystem, schedule: Schedule = .update, isUnique: Bool = true) {
        systemManager.add(system, schedule: schedule, isUnique: isUnique)
    }
}
