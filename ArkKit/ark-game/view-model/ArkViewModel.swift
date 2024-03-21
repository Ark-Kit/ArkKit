class ArkViewModel {
    weak var viewRendererDelegate: GameStateRenderer?
    var canvas: Canvas? {
        didSet {
            guard let currentCanvas = canvas, let canvasContext = gameModel.canvasContext else {
                return
            }
            viewRendererDelegate?.render(canvas: currentCanvas, with: canvasContext)
        }
    }
    private let gameModel: ArkGameModel
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
}
