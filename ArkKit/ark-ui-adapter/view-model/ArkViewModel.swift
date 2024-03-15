class ArkViewModel {
    weak var viewRendererDelegate: ViewRendererDelegate?
    var renderableGameState: RenderableGameState? {
        didSet {
            guard let currentGameState = renderableGameState else {
                return
            }
            viewRendererDelegate?.render(from: currentGameState)
        }
    }
    private let gameModel: ArkGameModel
    init(gameModel: ArkGameModel) {
        self.gameModel = gameModel
    }
    func updateGame(for dt: Double) {
        gameModel.updateState(dt: dt)
        takeSnapshotOfCurrentRenderables()
    }
    func takeSnapshotOfCurrentRenderables() {
        renderableGameState = gameModel.retrieveRenderableGameState()
    }
}
