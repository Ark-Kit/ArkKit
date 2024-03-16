class ArkGameModel {
    var gameState: ArkState?
    init(eventManager: ArkEventManager, arkECS: ArkECS) {
        gameState = ArkState(eventManager: eventManager, arkECS: arkECS)
    }
    func updateState(dt: Double) {
        gameState?.update(deltaTime: dt)
    }
    func retrieveCanvas() -> Canvas? {
        // TODO: implement logic to retrieve renderable components
        nil
    }
}
