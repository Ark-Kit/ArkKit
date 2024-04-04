protocol ArkView<View>: AbstractView,
                        GameStateRenderer,
                        GameLoopable,
                        ArkGameWorldUpdateLoopDelegate {
    associatedtype View

    var viewModel: ArkViewModel? { get set }
    var canvasRenderer: (any CanvasRenderer<View>)? { get set }
}
