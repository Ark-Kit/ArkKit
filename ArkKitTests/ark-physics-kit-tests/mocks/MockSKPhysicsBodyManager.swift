import Foundation
@testable import ArkKit

class MockSKPhysicsBodyManager: SKPhysicsBodyManager {
    var bodiesAdded: [(Entity, AbstractArkSKPhysicsBody)] = []
    var bodiesRemoved: [Entity] = []
    var impulsesApplied: [(Entity, CGVector)] = []
    var angularImpulsesApplied: [(Entity, CGFloat)] = []

    override func addBody(for entity: Entity, body: AbstractArkSKPhysicsBody) -> Bool {
        if super.addBody(for: entity, body: body) {
            bodiesAdded.append((entity, body))
            return true
        }
        return false
    }

    override func removeBody(for entity: Entity) {
        if getBody(for: entity) != nil {
            bodiesRemoved.append(entity)
            super.removeBody(for: entity)
        }
    }
}
