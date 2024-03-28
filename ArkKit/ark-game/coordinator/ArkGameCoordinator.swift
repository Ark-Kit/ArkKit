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
        let arkViewController = ArkUIKitViewController()
        let arkViewModel = ArkViewModel(gameModel: arkGameModel)

        // inject dependencies between M, V, VM
        arkViewController.viewModel = arkViewModel
        arkViewModel.viewRendererDelegate = arkViewController
        arkViewModel.viewDelegate = arkViewController

        // inject dependencies between game loop and view
        arkViewController.gameLoop = gameLoop
        self.gameLoop.updateGameWorldDelegate = arkViewController

        // push view-controller to rootView
        rootView.pushView(arkViewController, animated: false)
        arkViewController.didMove(to: rootView)
    }
}
