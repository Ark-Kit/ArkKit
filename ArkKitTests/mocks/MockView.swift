@testable import ArkKit

class MockView: ArkView {
    typealias View = Any
    init() {
        self.viewModel = nil
        self.renderableBuilder = nil
        self.gameLoop = nil
        self.abstractView = 1.0
    }
    var viewModel: ArkKit.ArkViewModel<View>?

    var renderableBuilder: (any ArkKit.RenderableBuilder<View>)?

    var abstractView: View

    func didMove(to parent: any ArkKit.AbstractParentView<View>) {
    }

    func render(_ canvas: any ArkKit.Canvas, with canvasContext: any ArkKit.CanvasContext<View>) {
    }

    func onScreenResize(_ delegate: @escaping ScreenResizeDelegate) {
    }

    var gameLoop: (any ArkKit.GameLoop)?

    func handleGameProgress(dt: Double) {
    }

    func update(for dt: Double) {
    }

}
