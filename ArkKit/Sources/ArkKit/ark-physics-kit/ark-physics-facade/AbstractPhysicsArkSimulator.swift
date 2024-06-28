import Foundation

protocol AbstractPhysicsArkSimulator: GameLoop {
    var physicsScene: AbstractArkPhysicsScene? { get set }
    func start()
    func pause()
    func resume()
    func stop()
}
