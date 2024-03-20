import UIKit

/**
 * `ArkViewController` is the main page that will render the game's canvas.
 */
class ArkViewController: UIViewController {
    private var displayLink: CADisplayLink?
    var viewModel: ArkViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpGameLoop()
    }
    @objc func handleGameProgress() {
        guard let target = displayLink?.targetTimestamp,
              let previous = displayLink?.timestamp else {
            return
        }
        let deltaTime = target - previous
        viewModel?.updateGame(for: deltaTime)
    }
    private func setUpGameLoop() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(handleGameProgress))
        self.displayLink?.add(to: .main, forMode: .default)
    }
}

extension ArkViewController: GameStateRenderer {
    func render(canvas: Canvas, with canvasContext: CanvasContext) {
        let canvasRenderer = ArkUIKitCanvasRenderer(rootView: self.view,
                                                    canvasFrame: canvasContext.canvasFrame)
        canvas.render(using: canvasRenderer, to: canvasContext)
    }
}
