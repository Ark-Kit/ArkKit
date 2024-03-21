import UIKit

/**
 * `ArkViewController` is the main page that will render the game's canvas.
 */
class ArkUIKitViewController: UIViewController, GameLoopable {
    var viewModel: ArkViewModel?
    var gameLoop: GameLoop?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.gameLoop = ArkGameLoop(({
            CADisplayLink(target: self,
                          selector: #selector(self.handleGameProgress))
        }))
        self.gameLoop?.setUp()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.gameLoop?.shutDown()
    }
    @objc func handleGameProgress() {
        guard let deltaTime = gameLoop?.getDeltaTime() else {
            return
        }
        viewModel?.updateGame(for: deltaTime)
    }
}

extension ArkUIKitViewController: GameStateRenderer {
    func render(canvas: Canvas, with canvasContext: CanvasContext) {
        let canvasRenderer = ArkUIKitCanvasRenderer(rootView: self.view,
                                                    canvasFrame: canvasContext.canvasFrame)
        canvas.render(using: canvasRenderer, to: canvasContext)
    }
}

extension ArkUIKitViewController: AbstractChildView {
    func didMove(to parent: any AbstractParentView) {
        guard let parentViewController = parent as? UIViewController else {
            return
        }
        self.didMove(toParent: parentViewController)
    }
}
