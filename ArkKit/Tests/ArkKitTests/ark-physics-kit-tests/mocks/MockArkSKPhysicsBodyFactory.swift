import Foundation
@testable import ArkKit

class MockArkSKPhysicsBodyFactory: AbstractArkSKPhysicsBodyFactory {
    func createCirclePhysicsBody(for entity: Entity, radius: CGFloat,
                                 at position: CGPoint) -> AbstractArkSKPhysicsBody {
        MockArkSKPhysicsBody(circleOf: radius, at: position)
    }

    func createRectanglePhysicsBody(for entity: Entity, size: CGSize,
                                    at position: CGPoint) -> AbstractArkSKPhysicsBody {
        MockArkSKPhysicsBody(rectangleOf: size, at: position)
    }

    func createPolygonPhysicsBody(for entity: Entity, vertices: [CGPoint],
                                  at position: CGPoint) -> AbstractArkSKPhysicsBody {
        MockArkSKPhysicsBody(polygonOf: vertices, at: position)
    }
}
