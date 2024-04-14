@testable import ArkKit

class MockEventContext: ArkEventContext {
    var delegate: (any ArkKit.ArkEventContextDelegate)?

    func emitWithoutDelegate<Event>(_ event: Event) where Event: ArkKit.ArkEvent {
    }

    func emit<Event>(_ event: Event) where Event: ArkKit.ArkEvent {
    }
}
