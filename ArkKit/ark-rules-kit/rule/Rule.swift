protocol Rule {
    associatedtype Event: ArkEvent

    var event: Event.Type { get }
    var action: any Action<Event> { get }
}

struct ArkRule<Event: ArkEvent>: Rule {
    let event: Event.Type
    let action: any Action<Event>
}
