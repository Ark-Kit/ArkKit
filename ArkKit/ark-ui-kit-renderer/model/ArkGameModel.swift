import Foundation

class ArkGameModel {
    var gameState: ArkState?
    var canvasContext: CanvasContext?
    init(gameState: ArkState, canvasFrame: CGRect) {
        self.gameState = gameState
        canvasContext = ArkCanvasContext(ecs: gameState.arkECS, canvasFrame: canvasFrame)
    }
    func updateState(dt: Double) {
        gameState?.update(deltaTime: dt)
    }
    func retrieveCanvas() -> Canvas? {
        canvasContext?.getCanvas()
    }
}
