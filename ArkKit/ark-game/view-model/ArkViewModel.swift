import Foundation

class ArkViewModel {
    private let gameModel: ArkGameModel
    var arkSceneUpdateDelegate: ArkSceneUpdateDelegate?
    weak var viewRendererDelegate: GameStateRenderer?
    weak var viewDelegate: AbstractView? {
        didSet {
            guard let currentView = viewDelegate else {
                return
            }
            currentView.onScreenResize { newSize in
                self.didScreenResize(newSize)
            }
        }
    }

    var canvas: Canvas? {
        didSet {
            guard let currentCanvas = canvas, let canvasContext = gameModel.canvasContext else {
                return
            }
            viewRendererDelegate?.render(canvas: currentCanvas, with: canvasContext)
        }
    }

    init(gameModel: ArkGameModel) {
        self.gameModel = gameModel
    }

    func updateGame(for dt: Double) {
        gameModel.updateState(dt: dt)
        updateCanvas()
    }

    func updateCanvas() {
        canvas = gameModel.retrieveCanvas()
    }

    func didScreenResize(_ size: CGSize) {
        gameModel.resizeScreen(size)
    }
}

extension ArkViewModel: ArkSceneUpdateDelegate {
    // Need to push this delegation of events to ArkPhysicsSystem somehow
    func didContactBegin(between entityA: Entity, and entityB: Entity) {
        arkSceneUpdateDelegate?.didContactBegin(between: entityA, and: entityB)
    }

    func didContactEnd(between entityA: Entity, and entityB: Entity) {
        arkSceneUpdateDelegate?.didContactEnd(between: entityA, and: entityB)
    }

    func didFinishUpdate(_ deltaTime: TimeInterval) {
        arkSceneUpdateDelegate?.didFinishUpdate(deltaTime)
        self.updateGame(for: deltaTime)
    }
}
