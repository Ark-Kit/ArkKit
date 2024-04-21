import XCTest
@testable import ArkKit

class ArkHostNetworkPublisherTests: XCTestCase {

    func testInitializationAndPlayerStateSetup() {
        let mockNetworkService = MockNetworkService(serviceName: "TestService")
        let mockPlayerStateSetupDelegate = MockPlayerStateSetupDelegate()
        let publisher = ArkHostNetworkPublisher(publishTo: mockNetworkService,
                                                playerStateSetUpDelegate: mockPlayerStateSetupDelegate)

        XCTAssertEqual(publisher.peerInfoToPlayerIdMap[mockNetworkService.deviceID], 0,
                       "Host should be assigned player ID 0")
        XCTAssertEqual(mockPlayerStateSetupDelegate.setupPlayerId, 0, "Player state should be set up with ID 0")
    }

    func testPublishECS() {
        let mockNetworkService = MockNetworkService(serviceName: "TestService")
        let publisher = ArkHostNetworkPublisher(publishTo: mockNetworkService)
        let mockECS = ArkECS()

        publisher.publish(ecs: mockECS)

        XCTAssertNotNil(mockNetworkService.sentData, "ECS data should have been sent")
    }

    func testOnChangeInObservers() {
        let mockNetworkService = MockNetworkService(serviceName: "TestService")
        let publisher = ArkHostNetworkPublisher(publishTo: mockNetworkService)
        let connectedDevices = ["device1", "device2"]

        publisher.onChangeInObservers(manager: mockNetworkService, connectedDevices: connectedDevices)

        XCTAssertEqual(publisher.peerInfoToPlayerIdMap.count, 3, "Should include host and 2 other peers")
        XCTAssertTrue(publisher.peerInfoToPlayerIdMap.contains(where: { $0.value == 1 }),
                      "New peer should have a new player ID")
        XCTAssertNotNil(mockNetworkService.sentData, "Data about peer-to-player ID mapping should have been sent")
    }
}
