import UIKit

/**
 * `ArkUIKitView` is the main page that will render the game's canvas.
 * It is `Ark`'s view for Apple's `UIKit` framework.
 */
class ArkUIKitView<T>: UIViewController, GameLoopable {
    var viewModel: ArkViewModel<T>?
    var gameLoop: GameLoop?
    var rootViewResizeDelegate: ScreenResizeDelegate?
    var cachedScreenSize: CGSize?
    var renderableBuilder: (any RenderableBuilder<UIView>)?
    var cameraContext: CameraContext?

    var rootView: UIView {
        view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupSimulator()
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

    func handleGameProgress(dt: Double) {
        viewModel?.updateGame(for: dt)
    }

    private func onRootViewResize(_ delegate: @escaping ScreenResizeDelegate) {
        self.rootViewResizeDelegate = delegate
    }
}

extension ArkUIKitView: GameStateRenderer {
    func render(flatCanvas: Canvas, with canvasContext: any CanvasContext<UIView>) {
        let renderableBuilder = renderableBuilder ?? ArkUIKitRenderableBuilder()

        // this canvas transform og canvas into mega canvas (Screen + Camera)
        let canvasToRender = cameraContext?.transform(flatCanvas) ?? flatCanvas
        // n camera containers + one screen container
        canvasContext.render(canvasToRender, using: renderableBuilder)
    }
}

extension ArkUIKitView<UIView>: AbstractView {
    func didMove(to parent: any AbstractParentView<UIView>) {
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

extension ArkUIKitView: ArkGameWorldUpdateLoopDelegate {
    func update(for dt: Double) {
        self.handleGameProgress(dt: dt)
    }
}

extension ArkUIKitView<UIView>: ArkView {
}
