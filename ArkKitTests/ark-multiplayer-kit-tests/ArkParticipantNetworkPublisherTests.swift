import XCTest
@testable import ArkKit

class ArkParticipantNetworkPublisherTests: XCTestCase {

    func testInitialization() {
        let mockNetworkService = MockNetworkService(serviceName: "TestService")
        let publisher = ArkParticipantNetworkPublisher(publishTo: mockNetworkService)

        XCTAssertNotNil(publisher.networkService, "Network service should not be nil")
        XCTAssertTrue(mockNetworkService.publisher === publisher,
                      "Publisher should be set correctly on the network service")
    }

    func testPublishEvent() {
        let mockNetworkService = MockNetworkService(serviceName: "TestService")
        let publisher = ArkParticipantNetworkPublisher(publishTo: mockNetworkService)
        let testEvent = TestEvent(eventData: TestEventData(name: "Test Message"))

        publisher.publish(event: testEvent)

        XCTAssertNotNil(mockNetworkService.sentData, "Data should have been sent")
    }
}
