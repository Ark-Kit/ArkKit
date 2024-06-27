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

        if cachedScreenSize != view.frame.size {
            rootViewResizeDelegate?(view.frame.size)
        }

        cachedScreenSize = view.frame.size
    }

    func handleGameProgress(dt: Double) {
        viewModel?.updateGame(for: dt)
    }

    private func onRootViewResize(_ delegate: @escaping ScreenResizeDelegate) {
        self.rootViewResizeDelegate = delegate
    }
}

extension ArkUIKitView: GameStateRenderer {
    func render(_ canvas: Canvas, with canvasContext: any CanvasContext<UIView>) {
        let renderableBuilder = renderableBuilder ?? ArkUIKitRenderableBuilder()
        canvasContext.render(canvas, using: renderableBuilder)
    }
}

extension ArkUIKitView<UIView>: AbstractView {
    var abstractView: UIView {
        self.view
    }

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
