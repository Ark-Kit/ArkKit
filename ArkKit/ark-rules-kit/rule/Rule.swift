protocol Rule {
    associatedtype Event: ArkEvent

    var event: ArkEventID { get }
    var action: any Action<Event> { get }
}

struct ArkRule<Event: ArkEvent>: Rule {
    let event: ArkEventID
    let action: any Action<Event>
}
