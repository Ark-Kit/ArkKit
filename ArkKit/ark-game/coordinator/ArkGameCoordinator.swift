import Foundation

class ArkGameCoordinator {
    let rootView: any AbstractParentView
    let arkState: ArkState
    let canvasContext: CanvasContext
    var gameLoop: GameLoop

    init(rootView: any AbstractParentView, arkState: ArkState,
         canvasContext: CanvasContext, gameLoop: GameLoop) {
        self.rootView = rootView
        self.arkState = arkState
        self.canvasContext = canvasContext
        self.gameLoop = gameLoop
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

        // push view-controller to rootView
        rootView.pushView(arkView, animated: false)
        arkView.didMove(to: rootView)
    }
}
