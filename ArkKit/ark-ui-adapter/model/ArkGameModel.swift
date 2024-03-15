class ArkGameModel {
    var gameState: ArkState?
    init(eventManager: ArkEventManager) {
        gameState = ArkState(eventManager: eventManager)
    }
    func updateState(dt: Double) {
        gameState?.update(deltaTime: dt)
    }
    func retrieveRenderableGameState() -> RenderableGameState? {
        // TODO: implement logic to retrieve renderable components
        nil
    }
}
