class ArkGameModel {
    var gameState: ArkState?
    var canvasContext: ArkCanvasContext?
    init(eventManager: ArkEventManager, arkECS: ArkECS) {
        gameState = ArkState(eventManager: eventManager, arkECS: arkECS)
        canvasContext = arkECS
    }
    func updateState(dt: Double) {
        gameState?.update(deltaTime: dt)
    }
    func retrieveCanvas() -> Canvas? {
        canvasContext?.getCanvas()
    }
}
