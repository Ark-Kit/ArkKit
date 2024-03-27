import Foundation

protocol AbstractPhysicsArkSimulator: GameLoop {
    var gameScene: AbstractArkPhysicsScene { get set }
    func start()
    func stop()
}
