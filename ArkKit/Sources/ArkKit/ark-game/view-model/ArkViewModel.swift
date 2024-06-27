import Foundation

class ArkViewModel<T> {
    private let gameModel: ArkGameModel<T>

    weak var viewRendererDelegate: (any GameStateRenderer<T>)?
    weak var viewDelegate: (any AbstractView)? {
        didSet {
            guard let currentView = viewDelegate else {
                return
            }
            currentView.onScreenResize { newSize in
                self.didScreenResize(newSize)
            }
        }
    }

    var canvas: Canvas? {
        didSet {
            guard let currentCanvas = canvas, let canvasContext = gameModel.canvasContext else {
                return
            }
            let canvasToRender = gameModel.cameraContext?.transform(currentCanvas) ?? currentCanvas
            viewRendererDelegate?.render(canvasToRender, with: canvasContext)
        }
    }

    init(gameModel: ArkGameModel<T>) {
        self.gameModel = gameModel
    }

    func updateGame(for dt: Double) {
        gameModel.updateState(dt: dt)
        updateCanvas()
    }

    func updateCanvas() {
        canvas = gameModel.retrieveCanvas()
    }

    func didScreenResize(_ size: CGSize) {
        gameModel.resizeScreen(size)
    }
}
