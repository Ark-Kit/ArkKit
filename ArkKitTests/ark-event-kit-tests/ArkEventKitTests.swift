import XCTest
@testable import ArkKit

// Mock for ArkEventData
struct MockEventData: ArkEventData {
    var name: String
}

// Stubs for ArkEvent
struct EventStub: ArkEvent {
    static var id: ArkEventID = UUID()
    var eventData: ArkEventData
    var timestamp = Date()
    var priority: Int?

    init(name: String = "MockEvent", priority: Int = 1) {
        self.eventData = MockEventData(name: name)
        self.priority = priority
    }
}

struct EventStub1: ArkEvent {
    static var id: ArkEventID = UUID()
    var eventData: ArkEventData
    var timestamp = Date()
    var priority: Int?

    init(name: String = "MockEvent", priority: Int = 1) {
        self.eventData = MockEventData(name: name)
        self.priority = priority
    }
}

struct EventStub2: ArkEvent {
    static var id: ArkEventID = UUID()
    var eventData: ArkEventData
    var timestamp = Date()
    var priority: Int?

    init(name: String = "MockEvent", priority: Int = 1) {
        self.eventData = MockEventData(name: name)
        self.priority = priority
    }
}

class ArkEventKitTests: XCTestCase {

    var eventManager: ArkEventManager!

    override func setUp() {
        super.setUp()
        eventManager = ArkEventManager()
    }

    override func tearDown() {
        eventManager = nil
        super.tearDown()
    }

    func testSubscribeAddsListener() {
        let expectation = self.expectation(description: "Listener should be called")
        let eventID = EventStub.id

        eventManager.subscribe(to: eventID) { _ in
            expectation.fulfill()
        }

        var event = EventStub()
        eventManager.emit(&event)
        eventManager.processEvents()

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error, "Listener was not called")
        }
    }

    func testMultipleSubscriptionsToSameEventID() {
        let expectation1 = expectation(description: "First listener should be called")
        let expectation2 = expectation(description: "Second listener should be called")
        let eventID = EventStub.id

        eventManager.subscribe(to: eventID) { _ in
            expectation1.fulfill()
        }

        eventManager.subscribe(to: eventID) { _ in
            expectation2.fulfill()
        }

        var event = EventStub() // Default event
        eventManager.emit(&event)
        eventManager.processEvents()

        wait(for: [expectation1, expectation2], timeout: 1)
    }

    func testEventPriorityHandling() {
        var highPriorityEvent = EventStub1(priority: 3) // High priority event
        var lowPriorityEvent = EventStub2(priority: 1) // Low priority event

        var executionOrder: [Int] = []

        eventManager.subscribe(to: EventStub1.id) { event in
            executionOrder.append(event.priority ?? 0)
        }

        eventManager.subscribe(to: EventStub2.id) { event in
            executionOrder.append(event.priority ?? 0)
        }

        eventManager.emit(&highPriorityEvent)
        eventManager.emit(&lowPriorityEvent)

        XCTAssertEqual(executionOrder, [], "Array should be empty")

        eventManager.processEvents()

        XCTAssertEqual(executionOrder, [3, 1], "Events were not processed in the correct order")
    }

    func testEventTimestampOrdering() {
        var secondEvent = EventStub2(name: "SecondEvent", priority: 1)
        var firstEvent = EventStub1(name: "FirstEvent", priority: 1)

        var handledEventsNames: [String] = []

        eventManager.subscribe(to: EventStub2.id) { _ in
            handledEventsNames.append("SecondEvent")
        }

        eventManager.subscribe(to: EventStub1.id) { _ in
            handledEventsNames.append("FirstEvent")
        }

        eventManager.emit(&firstEvent)
        eventManager.emit(&secondEvent)
        eventManager.processEvents()

        XCTAssertEqual(handledEventsNames, ["FirstEvent", "SecondEvent"],
                       "Events with the same priority should be handled in the order they were emitted")
    }

    func testEventModificationInListener() {
        var event = EventStub(name: "OriginalEvent", priority: 1)
        var modificationFlag = false

        eventManager.subscribe(to: EventStub.id) { event in
            var modifiableEvent = event
            modifiableEvent.priority = 3 // Attempt to modify event's priority
            modificationFlag = true
        }

        eventManager.emit(&event)
        eventManager.processEvents()

        XCTAssertTrue(modificationFlag, "The event listener should have been called and attempted a modification")
        XCTAssertEqual(event.priority, 1, "The original event's priority should remain unchanged after listener execution")
    }

    func testProcessingEventsGeneratesNewEvents() {
        var initialEvent = EventStub( name: "InitialEvent", priority: 1)
        let newEventName = "NewEvent"

        eventManager.subscribe(to: EventStub.id) { [weak self] _ in
            var newEvent = EventStub1(name: newEventName, priority: 2)
            self?.eventManager.emit(&newEvent)
        }

        var newEventTriggered = false
        eventManager.subscribe(to: EventStub1.id) { _ in
            newEventTriggered = true
        }

        eventManager.emit(&initialEvent)
        eventManager.processEvents()
        eventManager.processEvents()

        XCTAssertTrue(newEventTriggered, "New event generated during processing was also processed")
    }

}
