import Foundation

class ArkViewModel {
    weak var viewRendererDelegate: GameStateRenderer?
    var arkSceneUpdateDelegate: ArkSceneUpdateDelegate?

    var canvas: Canvas? {
        didSet {
            guard let currentCanvas = canvas, let canvasContext = gameModel.canvasContext else {
                return
            }
            viewRendererDelegate?.render(canvas: currentCanvas, with: canvasContext)
        }
    }
    private let gameModel: ArkGameModel
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
