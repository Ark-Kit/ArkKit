import XCTest
@testable import ArkKit

class SystemManagerTests: XCTestCase {

    class MockSystem: UpdateSystem {
        var active = true

        private(set) var updateCalled = false
        private(set) var lastDeltaTime: TimeInterval?

        func update(deltaTime: TimeInterval, arkECS: ArkECS) {
            updateCalled = true
            lastDeltaTime = deltaTime
        }

        func reset() {
            updateCalled = false
            lastDeltaTime = nil
        }
    }

    func testAddSystemAddsSystem() {
        let systemManager = SystemManager()
        let testSystem = MockSystem()

        systemManager.add(testSystem)

        let retrievedSystem: [MockSystem] = systemManager.system(ofType: MockSystem.self)
        XCTAssertEqual(retrievedSystem.count, 1, "System should be added to the manager.")
    }

    func testRemoveSystemRemovesSystem() {
        let systemManager = SystemManager()
        let testSystem = MockSystem()  // Assuming MockSystem conforms to your System protocol
        systemManager.add(testSystem)

        systemManager.remove(ofType: MockSystem.self)

        let retrievedSystems: [MockSystem] = systemManager.system(ofType: MockSystem.self)
        XCTAssertEqual(retrievedSystems.count, 0, "System should be removed from the manager.")
    }

    func testSystemReturnsCorrectSystem() {
        let systemManager = SystemManager()
        let testSystem = MockSystem()  // Assuming MockSystem conforms to your System protocol
        systemManager.add(testSystem)

        let retrievedSystems: [MockSystem] = systemManager.system(ofType: MockSystem.self)

        XCTAssertEqual(retrievedSystems.count, 1, "The correct system should be retrieved.")
    }

    func testUpdateCallsUpdateOnAllSystems() {
        let systemManager = SystemManager()
        let mockSystem = MockSystem()
        systemManager.add(mockSystem)
        let deltaTime: TimeInterval = 0.16  // Example delta time
        let arkECS = ArkECS()

        systemManager.update(deltaTime: deltaTime, arkECS: arkECS)

        XCTAssertTrue(mockSystem.updateCalled, "Update should be called on all systems.")
        XCTAssertEqual(mockSystem.lastDeltaTime, deltaTime, "Update should be called with the correct delta time.")
    }

}
