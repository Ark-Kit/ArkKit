import Foundation

class ArkEntityRemovalSystem: UpdateSystem {
    var active: Bool

    init(active: Bool = true) {
        self.active = active
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        let toRemoveEntities = arkECS.getEntities(with: [ToRemoveComponent.self])
        for entity in toRemoveEntities {
            guard let toRemoveComponent = arkECS.getComponent(ofType: ToRemoveComponent.self,
                                                              for: entity),
                    toRemoveComponent.toBeRemoved else {
                continue
            }
            arkECS.removeEntity(entity)
        }
    }
}
