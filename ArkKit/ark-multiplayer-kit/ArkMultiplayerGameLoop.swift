class ArkMultiplayerGameLoop: GameLoop {
    var updatePhysicsSceneDelegate: (any ArkPhysicsSceneUpdateLoopDelegate)?

    var updateGameWorldDelegate: (any ArkGameWorldUpdateLoopDelegate)?

    func setUp() {
    }

    func update() {
    }

    func getDeltaTime() -> Double {
        0.0
    }

    func shutDown() {
    }

    func pauseLoop() {
    }

    func resumeLoop() {
    }
}

protocol ArkMultiplayerECSDelegate {

}
