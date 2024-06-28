import Foundation

class ArkEntityRemovalSystem: UpdateSystem {
    var active: Bool

    var arkPhysicsRemovalDelegate: ArkPhysicsRemovalDelegate?

    init(active: Bool = true) {
        self.active = active
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        let toBeRemovedEntities = arkECS.getEntities(with: [ToRemoveComponent.self])
        for entity in toBeRemovedEntities {
            guard let toRemoveComponent = arkECS.getComponent(ofType: ToRemoveComponent.self, for: entity) else {
                continue
            }
            arkECS.removeEntity(entity)
            guard let arkPhysicsRemovalDelegate = arkPhysicsRemovalDelegate else {
                continue
            }
            arkPhysicsRemovalDelegate.removePhysicsBody(for: entity)
        }
    }
}
