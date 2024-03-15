class ArkViewModel {
    weak var viewRendererDelegate: GameStateRenderer?
    var canvas: Canvas? {
        didSet {
            guard let currentCanvas = canvas else {
                return
            }
            viewRendererDelegate?.render(canvas: currentCanvas)
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
