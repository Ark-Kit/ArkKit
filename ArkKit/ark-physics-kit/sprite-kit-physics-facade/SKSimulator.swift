import SpriteKit

class SKSimulator: NSObject, AbstractPhysicsArkSimulator {
    let view: SKView
    var physicsScene: AbstractArkPhysicsScene?
    weak var updatePhysicsSceneDelegate: ArkPhysicsSceneUpdateLoopDelegate?
    weak var updateGameWorldDelegate: ArkGameWorldUpdateLoopDelegate?

    init(size: CGSize) {
        self.view = SKView()
        super.init()
        let physicsScene = SKPhysicsScene(size: size, delegate: self)
        self.physicsScene = physicsScene
    }

    func start() {
        guard let gameScene = self.physicsScene as? SKPhysicsScene else {
            assertionFailure("SKSimulator should use SKPhysicsScene")
            return
        }
        view.presentScene(gameScene.basePhysicsScene)
    }

    func pause() {
        view.isPaused = true
    }

    func resume() {
        guard view.scene != nil else {
            assertionFailure("[SKSimulator.resume] cannot resume without having started")
            return
        }
        view.isPaused = false
    }

    func stop() {
        view.presentScene(nil)
    }
}

extension SKSimulator: GameLoop {
    func update() {
        let deltaTime = self.getDeltaTime()
        self.updatePhysicsSceneDelegate?.update(deltaTime)
        self.updateGameWorldDelegate?.update(for: deltaTime)

    }

    func setUp() {
        self.start()
    }

    func getDeltaTime() -> Double {
        self.physicsScene?.getDeltaTime() ?? 1 / 60
    }

    func shutDown() {
        self.stop()
    }

    func pauseLoop() {
        self.pause()
    }

    func resumeLoop() {
        self.resume()
    }
}

extension SKSimulator: SKSceneDelegate {
    func didFinishUpdate(for scene: SKScene) {
        self.update()
    }
}
