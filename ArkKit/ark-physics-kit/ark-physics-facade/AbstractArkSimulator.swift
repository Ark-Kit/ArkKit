import Foundation

protocol AbstractArkSimulator: GameLoop {
    var gameScene: AbstractArkGameScene { get set }
    func start()
    func stop()
}
