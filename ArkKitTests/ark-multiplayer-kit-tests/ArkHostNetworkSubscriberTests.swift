import XCTest
@testable import ArkKit

class ArkHostNetworkSubscriberTests: XCTestCase {

    func testInitialization() {
        let mockNetworkService = MockNetworkService(serviceName: "TestService")
        let subscriber = ArkHostNetworkSubscriber(subscribeTo: mockNetworkService)

        XCTAssertNotNil(subscriber.networkService, "Network service should not be nil")
        XCTAssertTrue(subscriber.networkService?.subscriber === subscriber,
                      "Subscriber should be set correctly on the network service")
    }

    func testOnListenWithValidEventData() throws {
        let mockNetworkService = MockNetworkService(serviceName: "TestService")
        let mockEventManager = MockEventManager()
        let mockECS = ArkECS()
        let localState = ArkState(eventManager: mockEventManager, arkECS: mockECS)
        let subscriber = ArkHostNetworkSubscriber(subscribeTo: mockNetworkService)
        subscriber.localState = localState

        let testEvent = TestEvent(eventData: TestEventData(name: "Test Message"))
        let dataWrapper = DataWrapper(type: .event, name: "TestEvent",
                                      payload: try JSONEncoder().encode(testEvent))
        let data = try JSONEncoder().encode(dataWrapper)
        mockEventManager.subscribe(to: TestEvent.self) { _ in }

        subscriber.onListen(data)

        guard let receivedEvent = mockEventManager.lastEvent as? TestEvent else {
            return XCTFail("Expected event not emitted")
        }

        XCTAssertEqual(receivedEvent.eventData.name, "Test Message",
                       "The message of the event should match the input")
    }

    func testOnListenWithInvalidData() {
        let mockNetworkService = MockNetworkService(serviceName: "TestService")
        let subscriber = ArkHostNetworkSubscriber(subscribeTo: mockNetworkService)

        let invalidData = Data("invalid data".utf8)
        subscriber.onListen(invalidData)

        XCTAssertTrue(true, "Method should handle invalid data without crashing")
    }
}

class MockEventManager: ArkEventManager {
    var lastEvent: (any ArkEvent)?

    override func emit<Event>(_ event: Event) where Event: ArkEvent {
        lastEvent = event
        super.emit(event)
    }
}

struct TestEvent: ArkEvent, ArkSerializableEvent {
    var eventData: TestEventData
    var priority: Int?
}

struct TestEventData: ArkEventData, ArkSerializableEventData {
    var name: String
}
