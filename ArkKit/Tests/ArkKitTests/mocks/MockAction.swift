@testable import ArkKit

class MockAction<Event: ArkEvent, ExternalResources: ArkExternalResources>: Action {
    var priority: Int = 0

    // Implement the execute method to store executed events and contexts
    private(set) var executedEvents: [(event: Event, context: ArkActionContext<ExternalResources>)] = []

    // Implement the execute method required by the Action protocol
    func execute(_ event: Event, context: ArkActionContext<ExternalResources>) {
        // Store the executed event and context
        executedEvents.append((event, context))
    }
}
