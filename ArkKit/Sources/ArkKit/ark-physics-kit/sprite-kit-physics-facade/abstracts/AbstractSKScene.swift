import SpriteKit

protocol AbstractSKSceneProtocol: AnyObject {
    var gameScene: SKPhysicsScene? { get set }
    var sceneContactUpdateDelegate: ArkPhysicsContactUpdateDelegate? { get set }
    var sceneUpdateLoopDelegate: ArkPhysicsSceneUpdateLoopDelegate? { get set }
    var currentTime: TimeInterval { get set }
    var deltaTime: TimeInterval { get }

    func update(_ currentTime: TimeInterval)
}

class AbstractSKScene: SKScene, AbstractSKSceneProtocol {
    weak var gameScene: SKPhysicsScene?
    weak var sceneContactUpdateDelegate: ArkPhysicsContactUpdateDelegate?
    weak var sceneUpdateLoopDelegate: ArkPhysicsSceneUpdateLoopDelegate?

    var currentTime: TimeInterval = 0
    private var lastUpdateTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0

    func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if lastUpdateTime.isZero {
            lastUpdateTime = currentTime
        }
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        return deltaTime
    }

    override func update(_ currentTime: TimeInterval) {
        deltaTime = calculateDeltaTime(from: currentTime)
        self.currentTime = currentTime
    }
}
