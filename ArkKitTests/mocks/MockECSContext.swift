@testable import ArkKit

class MockECSContext: ArkECSContext {
    func createEntity() -> ArkKit.Entity {
        ArkKit.Entity()
    }

    func removeEntity(_ entity: ArkKit.Entity) {
    }

    func upsertComponent<T>(_ component: T, to entity: ArkKit.Entity) where T: ArkKit.Component {
    }

    func getComponent<T>(ofType type: T.Type, for entity: ArkKit.Entity) -> T? where T: ArkKit.Component {
        nil
    }

    func createEntity(with components: [any ArkKit.Component]) -> ArkKit.Entity {
        Entity()
    }

    func getEntities(with componentTypes: [any ArkKit.Component.Type]) -> [ArkKit.Entity] {
        []
    }

    func getComponents(from entity: ArkKit.Entity) -> [any ArkKit.Component] {
        []
    }

    func getEntity(id: ArkKit.EntityID) -> ArkKit.Entity? {
        nil
    }

    func addSystem(_ system: any ArkKit.UpdateSystem) {
    }
}
