class ArkMultiplayerGameLoop: GameLoop {
    var updatePhysicsSceneDelegate: (any ArkPhysicsSceneUpdateLoopDelegate)?

    weak var updateGameWorldDelegate: ArkGameWorldUpdateLoopDelegate?

    func setUp() {
    }

    func update() {
        let deltaTime = self.getDeltaTime()
        self.updateGameWorldDelegate?.update(for: deltaTime)
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
