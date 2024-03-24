@testable import ArkKit

class MockAction<Event: ArkEvent>: Action {
    // Implement the execute method to store executed events and contexts
    private(set) var executedEvents: [(event: Event, context: ArkActionContext)] = []

    // Implement the execute method required by the Action protocol
    func execute(_ event: Event, context: ArkActionContext) {
        // Store the executed event and context
        executedEvents.append((event, context))
    }
}
