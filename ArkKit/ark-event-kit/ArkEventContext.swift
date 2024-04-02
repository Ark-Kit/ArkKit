protocol ArkEventContext {
    typealias EventListener = (any ArkEvent) -> Void
    var delegate: ArkEventContextDelegate? { get set }

    func emit<Event: ArkEvent>(_ event: Event)
    func emitWithoutDelegate<Event: ArkEvent>(_ event: Event)
    func subscribe<Event: ArkEvent>(to eventType: Event.Type, _ listener: @escaping EventListener)
}

protocol ArkEventContextDelegate: AnyObject {
    func didEmitEvent<Event: ArkEvent>(_ event: Event)
}
