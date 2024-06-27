import XCTest
@testable import ArkKit

class ArkMultiplayerGameLoopTests: XCTestCase {

    func testUpdateCallsDelegateWithCorrectDeltaTime() {
        let gameLoop = ArkMultiplayerGameLoop()
        let mockDelegate = MockGameWorldUpdateLoopDelegate()
        gameLoop.updateGameWorldDelegate = mockDelegate

        gameLoop.update()

        XCTAssertTrue(mockDelegate.didUpdate, "Delegate should be called during update")
        XCTAssertEqual(mockDelegate.lastDeltaTime, 0.0, "Delta time should be passed correctly to delegate")
    }

    func testPhysicsDelegateNotCalledDuringUpdate() {
        let gameLoop = ArkMultiplayerGameLoop()
        let mockPhysicsDelegate = MockPhysicsSceneUpdateLoopDelegate()
        gameLoop.updatePhysicsSceneDelegate = mockPhysicsDelegate

        gameLoop.update()

        XCTAssertFalse(mockPhysicsDelegate.didUpdate, "Physics delegate should not be called during update")
        XCTAssertNil(mockPhysicsDelegate.lastDeltaTime, "Physics delta time should be nil")
    }
}
