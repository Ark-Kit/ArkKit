enum RuleTrigger {
    case updateSystem
    static func event(_ eventId: ArkEventID) -> ArkEventID {
        eventId
    }
}
