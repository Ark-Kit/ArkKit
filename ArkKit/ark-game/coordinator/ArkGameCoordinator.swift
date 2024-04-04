import Foundation

class ArkGameCoordinator<View> {
    let rootView: any AbstractParentView<View>
    let arkState: ArkState
    let canvasContext: CanvasContext
    var gameLoop: GameLoop

    var canvasRenderer: (any CanvasRenderer<View>)?

    init(rootView: any AbstractParentView<View>,
         arkState: ArkState,
         canvasContext: CanvasContext,
         gameLoop: GameLoop,
         canvasRenderer: (any CanvasRenderer<View>)? = nil
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
        arkView.cameraContext = ArkCameraContext(ecs: arkState.arkECS)

        // push view-controller to rootView
        rootView.pushView(arkView, animated: false)
        arkView.didMove(to: rootView)

        // inject renderer dependency into arkView
        arkView.canvasRenderer = canvasRenderer
    }
}
