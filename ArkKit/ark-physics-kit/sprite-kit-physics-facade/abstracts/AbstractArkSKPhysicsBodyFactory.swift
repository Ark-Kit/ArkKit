import Foundation

protocol AbstractArkSKPhysicsBodyFactory {
    func createCirclePhysicsBody(for entity: Entity, radius: CGFloat,
                                 at position: CGPoint) -> any AbstractArkSKPhysicsBody
    func createRectanglePhysicsBody(for entity: Entity, size: CGSize,
                                    at position: CGPoint) -> any AbstractArkSKPhysicsBody
    func createPolygonPhysicsBody(for entity: Entity, vertices: [CGPoint],
                                  at position: CGPoint) -> any AbstractArkSKPhysicsBody
}
