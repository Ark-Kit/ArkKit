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

    func resizeScreen(_ size: CGSize) {
        let eventData = ScreenResizeEventData(
            name: "DisplayUpdateEvent",
            newSize: size
        )
        var event = ScreenResizeEvent(eventData: eventData)
        gameState?.eventManager.emit(&event)
    }

    func retrieveCanvas() -> Canvas? {
        canvasContext?.getCanvas()
    }
}
