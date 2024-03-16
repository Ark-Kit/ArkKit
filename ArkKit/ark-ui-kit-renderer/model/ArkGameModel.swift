class ArkGameModel {
    var gameState: ArkState?
    init(eventManager: ArkEventManager) {
        gameState = ArkState(eventManager: eventManager)
    }
    func updateState(dt: Double) {
        gameState?.update(deltaTime: dt)
    }
    func retrieveCanvas() -> Canvas? {
        // TODO: implement logic to retrieve renderable components
        nil
    }
}
