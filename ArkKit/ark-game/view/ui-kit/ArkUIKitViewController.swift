import UIKit

/**
 * `ArkViewController` is the main page that will render the game's canvas.
 */
class ArkUIKitViewController: UIViewController, GameLoopable {
    var viewModel: ArkViewModel?
    var gameLoop: GameLoop?
    var canvasView: UIView?
    var rootViewResizeDelegate: ScreenResizeDelegate?
    var cachedScreenSize: CGSize?

    var rootView: UIView {
        view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupSimulator()
        rootView.backgroundColor = .black

//        self.gameLoop = ArkGameLoop(({
//            CADisplayLink(target: self,
//                          selector: #selector(self.handleGameProgress))
//        }))
//        self.gameLoop?.setUp()
        let canvasView = UIView()
        canvasView.backgroundColor = .white
        rootView.addSubview(canvasView)

        self.canvasView = canvasView
    }

    func setupSimulator() {
        gameLoop?.setUp()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if cachedScreenSize != rootView.frame.size {
            rootViewResizeDelegate?(rootView.frame.size)
        }

        cachedScreenSize = rootView.frame.size
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

    private func onRootViewResize(_ delegate: @escaping ScreenResizeDelegate) {
        self.rootViewResizeDelegate = delegate
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
        canvasContext.render(canvas, using: canvasRenderer)
    }
}

extension ArkUIKitViewController: AbstractView {
    func didMove(to parent: any AbstractParentView) {
        guard let parentViewController = parent as? UIViewController else {
            return
        }
        self.didMove(toParent: parentViewController)
    }
    func onScreenResize(_ delegate: @escaping ScreenResizeDelegate) {
        onRootViewResize { newSize in
            delegate(newSize)
        }
    }
}
