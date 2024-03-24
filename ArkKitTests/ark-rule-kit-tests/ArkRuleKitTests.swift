import XCTest
@testable import ArkKit

class ArkRuleKitTests: XCTestCase {
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
}
