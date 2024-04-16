import Foundation

typealias ComponentID = UUID

protocol Component {
}

extension Component {
    func markForRemoval(entity: Entity, ecs: ArkECSContext) {
        ecs.upsertComponent(ToRemoveComponent(), to: entity)
    }

    func unmarkForRemoval(entity: Entity, ecs: ArkECSContext) {
        ecs.removeComponent(ofType: ToRemoveComponent.self, from: entity)
    }
}
