class ArkViewModel {
    weak var viewRendererDelegate: GameStateRenderer?
    var renderableGameState: RenderableGameState? {
        didSet {
            guard let currentGameState = renderableGameState else {
                return
            }
            viewRendererDelegate?.render(gameState: currentGameState)
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
