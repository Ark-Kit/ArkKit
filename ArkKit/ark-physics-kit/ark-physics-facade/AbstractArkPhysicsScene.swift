import Foundation

protocol AbstractArkPhysicsScene {
    var sceneContactUpdateDelegate: ArkPhysicsContactUpdateDelegate? { get set }
    var sceneUpdateLoopDelegate: ArkPhysicsSceneUpdateLoopDelegate? { get set }

    func getDeltaTime() -> TimeInterval
    func forEachEntity(perform action: (_ entity: Entity,
                                        _ physicsBody: AbstractArkPhysicsBody) -> Void)
    func createCirclePhysicsBody(for entity: Entity,
                                 withRadius radius: CGFloat,
                                 at position: CGPoint) -> AbstractArkPhysicsBody
    func createRectanglePhysicsBody(for entity: Entity,
                                    withSize size: CGSize,
                                    at position: CGPoint) -> AbstractArkPhysicsBody
    func getPhysicsBody(for entity: Entity) -> AbstractArkPhysicsBody?
    func removePhysicsBody(for entity: Entity)
    func apply(impulse: CGVector, to entity: Entity)
    func apply(angularImpulse: CGFloat, to entity: Entity)
}
