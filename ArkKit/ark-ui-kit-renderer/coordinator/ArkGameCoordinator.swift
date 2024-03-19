import UIKit

class ArkGameCoordinator {
    let rootView: UINavigationController
    let eventManager: ArkEventManager
    let arkECS: ArkECS
    init(rootView: UINavigationController, eventManager: ArkEventManager, arkECS: ArkECS) {
        self.rootView = rootView
        self.eventManager = eventManager
        self.arkECS = arkECS
    }
    func start() {
        // initiate key M, V, VM
        let arkGameModel = ArkGameModel(eventManager: eventManager, arkECS: arkECS)
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
