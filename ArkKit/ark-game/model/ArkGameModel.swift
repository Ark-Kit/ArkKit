import Foundation

class ArkGameModel<T> {
    var gameState: ArkState?
    var canvasContext: (any CanvasContext<T>)?

    init(gameState: ArkState, canvasContext: any CanvasContext<T>) {
        self.gameState = gameState
        self.canvasContext = canvasContext
        self.gameState?.startUp()
    }

    func updateState(dt: Double) {
        gameState?.update(deltaTime: dt)
    }

    func resizeScreen(_ size: CGSize) {
        let eventData = ScreenResizeEventData(
            name: "DisplayUpdateEvent",
            newSize: size
        )
        let event = ScreenResizeEvent(eventData: eventData)
        gameState?.eventManager.emit(event)
    }

    func retrieveCanvas() -> Canvas? {
        canvasContext?.getFlatCanvas()
    }
}
