import Foundation

class ArkSKPhysicsBodyFactory: AbstractArkSKPhysicsBodyFactory {
    func createCirclePhysicsBody(for entity: Entity, radius: CGFloat,
                                 at position: CGPoint) -> any AbstractArkSKPhysicsBody {
        ArkSKPhysicsBody(circleOf: radius, at: position)
    }

    func createRectanglePhysicsBody(for entity: Entity, size: CGSize,
                                    at position: CGPoint) -> any AbstractArkSKPhysicsBody {
        ArkSKPhysicsBody(rectangleOf: size, at: position)
    }

    func createPolygonPhysicsBody(for entity: Entity, vertices: [CGPoint],
                                  at position: CGPoint) -> any AbstractArkSKPhysicsBody {
        ArkSKPhysicsBody(polygonOf: vertices, at: position)
    }
}
