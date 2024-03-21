import Foundation

class ArkGameCoordinator {
    let rootView: any AbstractParentView
    let arkState: ArkState
    let canvasFrame: CGRect

    init(rootView: any AbstractParentView, arkState: ArkState, canvasFrame: CGRect) {
        self.rootView = rootView
        self.arkState = arkState
        self.canvasFrame = canvasFrame
    }

    func start() {
        // initiate key M, V, VM
        let arkGameModel = ArkGameModel(gameState: arkState, canvasFrame: canvasFrame)
        let arkViewController = ArkUIKitViewController()
        let arkViewModel = ArkViewModel(gameModel: arkGameModel)

        // inject dependencies between M, V, VM
        arkViewController.viewModel = arkViewModel
        arkViewModel.viewRendererDelegate = arkViewController

        // push view-controller to rootView
        rootView.pushView(arkViewController, animated: false)
        arkViewController.didMove(to: rootView)
    }
}
