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
        setupSimulator()
        let canvasView = UIView()
        canvasView.backgroundColor = .white
        self.view.addSubview(canvasView)

        self.canvasView = canvasView
    }
    
    func setupSimulator() {
        gameLoop?.setUp()
    }
    
    func handleGameProgress() {
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.canvasView?.removeFromSuperview()
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

extension ArkUIKitViewController: AbstractChildView {
    func didMove(to parent: any AbstractParentView) {
        guard let parentViewController = parent as? UIViewController else {
            return
        }
        self.didMove(toParent: parentViewController)
    }
}
