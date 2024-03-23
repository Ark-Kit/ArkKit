import Foundation

class ArkViewModel {
    private let gameModel: ArkGameModel
    weak var viewRendererDelegate: GameStateRenderer? {
        didSet {
            guard let currentViewRendererDelegate = viewRendererDelegate else {
                return
            }
            
            currentViewRendererDelegate.onScreenResize { newSize in
                self.didScreenResize(newSize)
            }
        }
    }
    
    var canvas: Canvas? {
        didSet {
            guard let currentCanvas = canvas, let canvasContext = gameModel.canvasContext else {
                return
            }
            viewRendererDelegate?.render(canvas: currentCanvas, with: canvasContext)
        }
    }
    
    init(gameModel: ArkGameModel) {
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
        gameModel.didScreenResize(size)
    }
}
