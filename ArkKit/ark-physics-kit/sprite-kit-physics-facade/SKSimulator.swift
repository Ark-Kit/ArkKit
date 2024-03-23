import SpriteKit

class SKSimulator: AbstractArkSimulator {
    let view: SKView
    var gameScene: AbstractArkGameScene

    init(size: CGSize) {
        self.view = SKView()
        self.gameScene = SKGameScene(size: size)
    }

    func start() {
        guard let gameScene = self.gameScene as? SKGameScene else {
            assertionFailure("SKSimulator should use SKGameScene")
            return
        }
        view.presentScene(gameScene.baseGameScene)
    }

    func stop() {
        view.presentScene(nil)
    }
}

extension SKSimulator: GameLoop {
    func setUp() {
        self.start()
    }

    func getDeltaTime() -> Double {
        self.gameScene.getDeltaTime()
    }

    func shutDown() {
        self.stop()
    }
}
