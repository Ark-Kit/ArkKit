import Foundation

protocol AbstractPhysicsArkSimulator: GameLoop {
    var physicsScene: AbstractArkPhysicsScene? { get set }
    func start()
    func stop()
}
