@testable import ArkKit
import Foundation
import SpriteKit

class MockArkPhysicsScene: AbstractArkPhysicsScene {
    func forEachEntity(perform action: (ArkKit.Entity, any ArkKit.AbstractArkPhysicsBody) -> Void) {
    }

    var sceneContactUpdateDelegate: ArkPhysicsContactUpdateDelegate?
    var sceneUpdateLoopDelegate: ArkPhysicsSceneUpdateLoopDelegate?
    var deltaTime: TimeInterval = 0
    private var entitiesToPhysicsBodies: [Entity: AbstractArkSKPhysicsBody] = [:]

    func getDeltaTime() -> TimeInterval {
        deltaTime
    }

    func forEachEntity(perform action: (Entity, AbstractArkSKPhysicsBody) -> Void) {
        for (_, body) in entitiesToPhysicsBodies {
            let entity = Entity()
            action(entity, body)
        }
    }

    func createCirclePhysicsBody(for entity: Entity, withRadius radius: CGFloat,
                                 at position: CGPoint) -> AbstractArkPhysicsBody {
        let body = MockArkSKPhysicsBody()
        body.position = position
        entitiesToPhysicsBodies[entity] = body
        return body
    }

    func createRectanglePhysicsBody(for entity: Entity, withSize size: CGSize,
                                    at position: CGPoint) -> AbstractArkPhysicsBody {
        let body = MockArkSKPhysicsBody()
        body.position = position
        entitiesToPhysicsBodies[entity] = body
        return body
    }

    func createPolygonPhysicsBody(for entity: Entity, withVertices vertices: [CGPoint],
                                  at position: CGPoint) -> AbstractArkPhysicsBody {
        let body = MockArkSKPhysicsBody()
        body.position = position
        entitiesToPhysicsBodies[entity] = body
        return body
    }

    func getPhysicsBody(for entity: Entity) -> AbstractArkPhysicsBody? {
        entitiesToPhysicsBodies[entity]
    }

    func removePhysicsBody(for entity: Entity) {
        entitiesToPhysicsBodies.removeValue(forKey: entity)
    }

    func apply(impulse: CGVector, to entity: Entity) {
        print("applying impulse to entity \(entity)")
        entitiesToPhysicsBodies[entity]?.applyImpulse(impulse)
    }

    func apply(angularImpulse: CGFloat, to entity: Entity) {
        entitiesToPhysicsBodies[entity]?.applyAngularImpulse(angularImpulse)
    }

    func setGravity(_ gravity: CGVector) {

    }
}
