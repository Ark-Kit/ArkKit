import UIKit

class ArkGameCoordinator {
    let rootView: UINavigationController
    let arkState: ArkState

    init(rootView: UINavigationController, arkState: ArkState) {
        self.rootView = rootView
        self.arkState = arkState
    }

    func start() {
        // initiate key M, V, VM
        let arkGameModel = ArkGameModel(gameState: arkState)
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
