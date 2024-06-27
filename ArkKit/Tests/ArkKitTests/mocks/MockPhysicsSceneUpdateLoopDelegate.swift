@testable import ArkKit

class MockPhysicsSceneUpdateLoopDelegate: ArkPhysicsSceneUpdateLoopDelegate {
    var didUpdate = false
    var lastDeltaTime: Double?

    func update(_ deltaTime: Double) {
        didUpdate = true
        lastDeltaTime = deltaTime
    }
}
