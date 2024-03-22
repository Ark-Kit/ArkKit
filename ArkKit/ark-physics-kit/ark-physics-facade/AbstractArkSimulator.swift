import Foundation

protocol AbstractArkSimulator {
    var gameScene: AbstractArkGameScene { get set }
    func start()
    func stop()
}
