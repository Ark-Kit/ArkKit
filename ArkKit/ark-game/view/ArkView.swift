protocol ArkView: AbstractView,
                  GameStateRenderer,
                  GameLoopable,
                  ArkGameWorldUpdateLoopDelegate {
    var viewModel: ArkViewModel? { get set }
    var canvasRenderer: (any CanvasRenderer)? { get set }
}
