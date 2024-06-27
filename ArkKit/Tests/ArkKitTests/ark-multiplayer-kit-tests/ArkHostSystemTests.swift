import XCTest
@testable import ArkKit

class ArkHostSystemTests: XCTestCase {

    func testUpdatePublishesECS() {
        let mockPublisher = MockHostNetworkPublisher(publishTo: MockNetworkService(serviceName: "TestService"))
        let hostSystem = ArkHostSystem(publisher: mockPublisher)
        let mockECS = ArkECS()

        hostSystem.update(deltaTime: 0.16, arkECS: mockECS)

        XCTAssertNotNil(mockPublisher.publishedECS, "The ECS should have been published")
        XCTAssertTrue(mockPublisher.publishedECS === mockECS, "The published ECS should be the same instance as provided")
    }

    func testSystemIsActive() {
        let mockPublisher = MockHostNetworkPublisher(publishTo: MockNetworkService(serviceName: "TestService"))
        let hostSystem = ArkHostSystem(publisher: mockPublisher, active: true)

        XCTAssertTrue(hostSystem.active, "The system should be active")

        hostSystem.active = false
        XCTAssertFalse(hostSystem.active, "The system should not be active")

    }
}
