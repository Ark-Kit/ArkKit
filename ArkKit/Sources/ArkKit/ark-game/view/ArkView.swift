protocol ArkView<View>: AbstractView,
                        GameStateRenderer,
                        GameLoopable,
                        ArkGameWorldUpdateLoopDelegate {
    associatedtype View
    var viewModel: ArkViewModel<View>? { get set }
    var renderableBuilder: (any RenderableBuilder<View>)? { get set }
}
