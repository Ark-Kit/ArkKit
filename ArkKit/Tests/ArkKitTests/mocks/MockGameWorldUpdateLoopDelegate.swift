@testable import ArkKit

class MockGameWorldUpdateLoopDelegate: ArkGameWorldUpdateLoopDelegate {
    var didUpdate = false
    var lastDeltaTime: Double?

    func update(for dt: Double) {
        didUpdate = true
        lastDeltaTime = dt
    }
}
