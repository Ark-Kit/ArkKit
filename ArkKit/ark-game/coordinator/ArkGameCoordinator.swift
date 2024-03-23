import Foundation

class ArkGameCoordinator {
    let rootView: any AbstractParentView
    let arkState: ArkState
    let canvasFrame: CGRect
    var gameLoop: AbstractArkSimulator
    var arkSceneUpdateDelegate: ArkSceneUpdateDelegate?

    init(rootView: any AbstractParentView, arkState: ArkState, canvasFrame: CGRect, gameLoop: AbstractArkSimulator) {
        self.rootView = rootView
        self.arkState = arkState
        self.canvasFrame = canvasFrame
        self.gameLoop = gameLoop
    }

    func start() {
        // initiate key M, V, VM
        let arkGameModel = ArkGameModel(gameState: arkState, canvasFrame: canvasFrame)
        let arkViewController = ArkUIKitViewController()
        let arkViewModel = ArkViewModel(gameModel: arkGameModel)

        // inject dependencies between M, V, VM
        arkViewController.viewModel = arkViewModel
        arkViewController.gameLoop = gameLoop
        arkViewModel.viewRendererDelegate = arkViewController
        arkViewModel.viewDelegate = arkViewController
        arkViewModel.arkSceneUpdateDelegate = self
        self.gameLoop.gameScene.sceneUpdateDelegate = arkViewModel

        // push view-controller to rootView
        rootView.pushView(arkViewController, animated: false)
        arkViewController.didMove(to: rootView)
    }
}

extension ArkGameCoordinator: ArkSceneUpdateDelegate {
    func didContactBegin(between entityA: Entity, and entityB: Entity) {
        arkSceneUpdateDelegate?.didContactBegin(between: entityA, and: entityB)
    }

    func didContactEnd(between entityA: Entity, and entityB: Entity) {
        arkSceneUpdateDelegate?.didContactEnd(between: entityA, and: entityB)
    }

    func didFinishUpdate(_ deltaTime: TimeInterval) {
        arkSceneUpdateDelegate?.didFinishUpdate(deltaTime)
    }
}
