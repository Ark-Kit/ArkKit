import Foundation

typealias ComponentID = UUID

public protocol Component {
}

extension Component {
    public func markForRemoval(entity: Entity, ecs: ArkECSContext) {
        ecs.upsertComponent(ToRemoveComponent(), to: entity)
    }

    public func unmarkForRemoval(entity: Entity, ecs: ArkECSContext) {
        ecs.removeComponent(ofType: ToRemoveComponent.self, from: entity)
    }
}
