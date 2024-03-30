import Foundation

class ArkGameCoordinator {
    let rootView: any AbstractParentView
    let arkState: ArkState
    let canvasContext: CanvasContext
    var gameLoop: GameLoop

    var canvasRenderer: (any CanvasRenderer)?

    init(rootView: any AbstractParentView,
         arkState: ArkState,
         canvasContext: CanvasContext,
         gameLoop: GameLoop,
         canvasRenderer: (any CanvasRenderer)? = nil
    ) {
        self.rootView = rootView
        self.arkState = arkState
        self.canvasContext = canvasContext
        self.gameLoop = gameLoop
        self.canvasRenderer = canvasRenderer
    }

    func start() {
        // initiate key M, V, VM
        let arkGameModel = ArkGameModel(gameState: arkState,
                                        canvasContext: canvasContext)
        guard var arkView = ArkViewFactory.generateView(rootView) else {
            return
        }
        let arkViewModel = ArkViewModel(gameModel: arkGameModel)

        // inject dependencies between M, V, VM
        arkView.viewModel = arkViewModel
        arkViewModel.viewRendererDelegate = arkView
        arkViewModel.viewDelegate = arkView

        // inject dependencies between game loop and view
        arkView.gameLoop = gameLoop
        gameLoop.updateGameWorldDelegate = arkView

        // inject renderer dependency into arkView
        arkView.canvasRenderer = canvasRenderer

        // push view-controller to rootView
        rootView.pushView(arkView, animated: false)
        arkView.didMove(to: rootView)
    }
}
