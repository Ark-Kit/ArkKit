protocol ArkEventContext {
    typealias EventListener = (any ArkEvent) -> Void

    func emit<Event: ArkEvent>(_ event: Event)
    func emitWithoutDelegate<Event: ArkEvent>(_ event: Event)
}

protocol ArkEventContextDelegate: AnyObject {
    func didEmitEvent<Event: ArkEvent>(_ event: Event)
}
