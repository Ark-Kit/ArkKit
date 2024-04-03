enum RuleTrigger {
    case updateSystem
    static func event<Event: ArkEvent>(_ eventType: Event.Type) -> RuleEventType {
        RuleEventType(eventType: eventType)
    }
}

struct RuleEventType: Equatable {
    let eventType: any ArkEvent.Type

    static func == (lhs: RuleEventType, rhs: RuleEventType) -> Bool {
        ObjectIdentifier(lhs.eventType) == ObjectIdentifier(rhs.eventType)
    }
}
