import Foundation

class ArkGameModel<T> {
    var gameState: ArkState?
    var canvasContext: (any CanvasContext<T>)?
    var cameraContext: (any CameraContext)?

    init(gameState: ArkState,
         canvasContext: any CanvasContext<T>,
         cameraContext: CameraContext) {
        self.gameState = gameState
        self.canvasContext = canvasContext
        self.cameraContext = cameraContext
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
