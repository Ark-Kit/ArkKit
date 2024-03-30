import Foundation

class ArkGameModel {
    var gameState: ArkState?
    var canvasContext: CanvasContext?

    init(gameState: ArkState, canvasContext: CanvasContext) {
        self.gameState = gameState
        self.canvasContext = canvasContext
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
        gameState?.eventManager.emit(event)
    }

    func retrieveCanvas() -> Canvas? {
        canvasContext?.getCanvas()
    }
}
