import Foundation

class ArkMultiplayerECS: ArkECSContext {
    let arkECS: ArkECS
    var delegate: ArkMultiplayerECSDelegate?
    
    init(arkECS: ArkECS = ArkECS(),
         delegate: ArkMultiplayerECSDelegate? = nil) {
        self.arkECS = arkECS
        self.delegate = delegate
    }
    func startUp() {
        arkECS.startUp()
    }

    func update(deltaTime: TimeInterval) {
        guard delegate?.isModificationEnabled ?? true else {
            return
        }
        
        arkECS.update(deltaTime: deltaTime)
    }

    func cleanUp() {
        arkECS.cleanUp()
    }

    @discardableResult
    func createEntity() -> Entity {
        guard delegate?.isModificationEnabled ?? true else { 
            return Entity()
        }
        
        let entity = arkECS.createEntity()
        delegate?.didCreateEntity(entity)
        return entity
    }
    
    func removeEntity(_ entity: Entity) {
        guard delegate?.isModificationEnabled ?? true else {
            return
        }
        
        arkECS.removeEntity(entity)
        delegate?.didRemoveEntity(entity)
    }

    func upsertComponent<T>(_ component: T, to entity: Entity) where T: Component {
        guard delegate?.isModificationEnabled ?? true else {
            return
        }

        arkECS.upsertComponent(component, to: entity)
        delegate?.didUpsertComponent(component, to: entity)
    }

    func removeComponent<T>(_ componentType: T.Type, from entity: Entity) where T: Component {
        guard delegate?.isModificationEnabled ?? true else {
            return
        }
        
        arkECS.removeComponent(componentType, from: entity)
        delegate?.didRemoveComponent(componentType, from: entity)
    }

    func getComponent<T>(ofType type: T.Type, for entity: Entity) -> T? where T: Component {
        return arkECS.getComponent(ofType: type, for: entity)
    }

    @discardableResult
    func createEntity(with components: [any Component]) -> Entity {
        guard delegate?.isModificationEnabled ?? true else {
            return Entity()
        }
        
        let entity = arkECS.createEntity(with: components)
        delegate?.didCreateEntity(entity, with: components)
        
        return entity
    }

    func getEntity(id: EntityID) -> Entity? {
        arkECS.getEntity(id: id)
    }

    func getEntities(with componentTypes: [any Component.Type]) -> [Entity] {
        arkECS.getEntities(with: componentTypes)
    }

    func getComponents(from entity: Entity) -> [any Component] {
        arkECS.getComponents(from: entity)
    }

    func addSystem(_ system: UpdateSystem, schedule: Schedule = .update, isUnique: Bool = true) {
        guard delegate?.isModificationEnabled ?? true else {
            return
        }
        
        arkECS.addSystem(system, schedule: .update, isUnique: isUnique)
    }
}

protocol ArkMultiplayerECSDelegate {
    var isModificationEnabled: Bool { get }
    func didCreateEntity(_ entity: Entity)
    func didRemoveEntity(_ entity: Entity)
    func didRemoveComponent<T: Component>(_ componentType: T.Type, from entity: Entity)
    func didUpsertComponent<T: Component>(_ component: T, to entity: Entity)
    func didCreateEntity(_ entity: Entity, with components: [Component])
}
