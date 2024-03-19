class ArkGameModel {
    var gameState: ArkState?
    var canvasContext: CanvasContext?
    init(gameState: ArkState) {
        self.gameState = gameState
        canvasContext = ArkCanvasContext(ecs: gameState.arkECS)
    }
    func updateState(dt: Double) {
        gameState?.update(deltaTime: dt)
    }
    func retrieveCanvas() -> Canvas? {
        canvasContext?.getCanvas()
    }
}
