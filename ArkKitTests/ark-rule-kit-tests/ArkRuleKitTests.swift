import XCTest
@testable import ArkKit

class ArkRuleKitTests: XCTestCase {

    /// UNIT TESTS
    func testActionExecution_shouldExecute() {
        let eventStub = EventStub()
        let actionContext = ArkActionContext(ecs: MockECSContext(),
                                             events: MockEventContext(),
                                             display: MockDisplayContext(),
                                             audio: MockAudioContext())
        let mockAction = MockAction<EventStub>()
        mockAction.execute(eventStub, context: actionContext)
        XCTAssertEqual(mockAction.executedEvents.count, 1)
    }

    func testArkRuleInit_shouldInit() {
        let mockAction = MockAction<EventStub>()
        let arkRule = ArkRule(event: EventStub.id, action: mockAction)
        XCTAssertEqual(arkRule.event, EventStub.id, "event id should match")
        XCTAssertTrue(arkRule.action is MockAction<EventStub>)
    }

    func testRuleActionExecution_shouldExecute() {
        let eventStub = EventStub()
        let actionContext = ArkActionContext(ecs: MockECSContext(),
                                             events: MockEventContext(),
                                             display: MockDisplayContext(),
                                             audio: MockAudioContext())
        let mockAction = MockAction<EventStub>()
        let arkRule = ArkRule(event: EventStub.id, action: mockAction)
        arkRule.action.execute(eventStub, context: actionContext)
        XCTAssertEqual(mockAction.executedEvents.count, 1,
                       "Action should have been executed once")
        XCTAssertEqual(mockAction.executedEvents[0].event.eventData.name,
                       "MockEvent",
                       "Executed event should match the provided event")
    }

    /// INTEGRATION TESTS
    func testForeverExecution_shouldExecuteTwice() {
        let eventManager = ArkEventManager()
        var executedEvents: [EventStub] = []

        let mockCallback: ActionCallback<EventStub> = { event, _ in
            executedEvents.append(event)
        }

        let forever = Forever(mockCallback)
        var eventStub = EventStub()
        let actionContext = ArkActionContext(ecs: MockECSContext(),
                                             events: eventManager,
                                             display: MockDisplayContext(),
                                             audio: MockAudioContext())
        eventManager.subscribe(to: EventStub.id, { event in
            guard let event = event as? EventStub else {
                return
            }
            forever.execute(event, context: actionContext)
        })
        eventManager.emit(&eventStub)
        eventManager.processEvents()
        XCTAssertEqual(executedEvents.count, 1, "Callback should be called")
        eventManager.emit(&eventStub)
        eventManager.processEvents()
        XCTAssertEqual(executedEvents.count, 2, "Callback should be called")
    }

    func testOnceExecution_shouldExecuteOnce() {
        let eventManager = ArkEventManager()
        var executedEvents: [EventStub] = []

        let mockCallback: ActionCallback<EventStub> = { event, _ in
            executedEvents.append(event)
        }

        let once = Once(mockCallback)
        var eventStub = EventStub()
        let actionContext = ArkActionContext(ecs: MockECSContext(),
                                             events: eventManager,
                                             display: MockDisplayContext(),
                                             audio: MockAudioContext())
        eventManager.subscribe(to: EventStub.id, { event in
            guard let event = event as? EventStub else {
                return
            }
            once.execute(event, context: actionContext)
        })
        eventManager.emit(&eventStub)
        eventManager.processEvents()
        XCTAssertEqual(executedEvents.count, 1, "Callback should be called")
        eventManager.emit(&eventStub)
        eventManager.processEvents()
        XCTAssertEqual(executedEvents.count, 1, "Callback should be called")
    }
}
