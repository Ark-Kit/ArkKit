import UIKit

/**
 * `ArkViewController` is the main page that will render the game's canvas.
 */
class ArkUIKitViewController: UIViewController, GameLoopable {
    var viewModel: ArkViewModel?
    var gameLoop: GameLoop?
    var canvasView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.gameLoop = ArkGameLoop(({
            CADisplayLink(target: self,
                          selector: #selector(self.handleGameProgress))
        }))
        self.gameLoop?.setUp()
        let canvasView = UIView()
        canvasView.backgroundColor = .white
        self.view.addSubview(canvasView)

        self.canvasView = canvasView
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.canvasView?.removeFromSuperview()
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
        guard let canvasView = self.canvasView else {
            return
        }

        canvasView.frame = canvasContext.canvasFrame

        let canvasRenderer = ArkUIKitCanvasRenderer(rootView: self.view,
                                                    canvasView: canvasView,
                                                    canvasFrame: canvasContext.canvasFrame)
        canvas.render(using: canvasRenderer, to: canvasContext)
    }
}

extension ArkUIKitViewController: AbstractView {
    func didMove(to parent: any AbstractParentView) {
        guard let parentViewController = parent as? UIViewController else {
            return
        }
        self.didMove(toParent: parentViewController)
    }
}
