import Foundation

class ArkGameCoordinator<View> {
    let rootView: any AbstractParentView<View>
    let arkState: ArkState
    let displayContext: any DisplayContext
    var gameLoop: GameLoop

    var canvasRenderer: (any RenderableBuilder<View>)?

    init(rootView: any AbstractParentView<View>,
         arkState: ArkState,
         displayContext: any DisplayContext,
         gameLoop: GameLoop,
         canvasRenderer: (any RenderableBuilder<View>)? = nil
    ) {
        self.rootView = rootView
        self.arkState = arkState
        self.displayContext = displayContext
        self.gameLoop = gameLoop
        self.canvasRenderer = canvasRenderer
    }

    func start() {
        // initiate key M, V, VM
        guard var arkView = ArkViewFactory.generateView(rootView) else {
            return
        }
        let canvasContext = ArkCanvasContext<View>(ecs: arkState.arkECS,
                                                   arkView: arkView)
        let cameraContext = ArkCameraContext(ecs: arkState.arkECS,
                                             displayContext: displayContext)
        let arkGameModel = ArkGameModel(gameState: arkState,
                                        canvasContext: canvasContext,
                                        cameraContext: cameraContext)
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

        // inject renderer dependency into arkView
        arkView.renderableBuilder = canvasRenderer
    }
}
