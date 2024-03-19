class ArkGameModel {
    var gameState: ArkState?
    var canvasContext: CanvasContext?
    init(eventManager: ArkEventManager, arkECS: ArkECS) {
        gameState = ArkState(eventManager: eventManager, arkECS: arkECS)
        canvasContext = ArkCanvasContext(ecs: arkECS)
    }
    func updateState(dt: Double) {
        gameState?.update(deltaTime: dt)
    }
    func retrieveCanvas() -> Canvas? {
        canvasContext?.getCanvas()
    }
}
