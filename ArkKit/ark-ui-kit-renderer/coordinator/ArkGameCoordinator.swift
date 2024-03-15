import UIKit

class ArkGameCoordinator {
    let rootView: UINavigationController
    let eventManager: ArkEventManager
    init(rootView: UINavigationController, eventManager: ArkEventManager) {
        self.rootView = rootView
        self.eventManager = eventManager
    }
    func start() {
        // initiate key M, V, VM
        let arkGameModel = ArkGameModel(eventManager: eventManager)
        let arkViewController = ArkViewController()
        let arkViewModel = ArkViewModel(gameModel: arkGameModel)

        // inject dependencies between M, V, VM
        arkViewModel.viewRendererDelegate = arkViewController

        // push view-controller to rootView
        rootView.pushViewController(arkViewController, animated: false)
        arkViewController.didMove(toParent: rootView)
    }
}
