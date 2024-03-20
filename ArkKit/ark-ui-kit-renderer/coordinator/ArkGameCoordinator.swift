import UIKit

class ArkGameCoordinator {
    let rootView: UINavigationController
    let arkState: ArkState
    let canvasFrame: CGRect

    init(rootView: UINavigationController, arkState: ArkState, canvasFrame: CGRect) {
        self.rootView = rootView
        self.arkState = arkState
        self.canvasFrame = canvasFrame
    }

    func start() {
        // initiate key M, V, VM
        let arkGameModel = ArkGameModel(gameState: arkState, canvasFrame: canvasFrame)
        let arkViewController = ArkViewController()
        let arkViewModel = ArkViewModel(gameModel: arkGameModel)

        // inject dependencies between M, V, VM
        arkViewController.viewModel = arkViewModel
        arkViewModel.viewRendererDelegate = arkViewController

        // push view-controller to rootView
        rootView.pushViewController(arkViewController, animated: false)
        arkViewController.didMove(toParent: rootView)
    }
}
