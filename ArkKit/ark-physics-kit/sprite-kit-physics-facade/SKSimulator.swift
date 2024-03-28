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
}

extension SKSimulator: SKSceneDelegate {
    func didFinishUpdate(for scene: SKScene) {
        self.update()
    }
}
