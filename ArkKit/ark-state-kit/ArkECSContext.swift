protocol ArkECSContext {
    @discardableResult func createEntity() -> Entity
    func removeEntity(_ entity: Entity)
    func upsertComponent<T: Component>(_ component: T, to entity: Entity)
    func removeComponent<T: Component>(ofType type: T.Type, from entity: Entity)
    func getComponent<T: Component>(ofType type: T.Type, for entity: Entity) -> T?
    @discardableResult func createEntity(with components: [Component]) -> Entity
    func getEntities(with componentTypes: [Component.Type]) -> [Entity]
    func getComponents(from entity: Entity) -> [Component]
    func getEntity(id: EntityID) -> Entity?
}
