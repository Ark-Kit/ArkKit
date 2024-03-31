protocol ArkEventContext {
    typealias EventListener = (any ArkEvent) -> Void

    func emit<Event: ArkEvent>(_ event: Event)
    func subscribe<Event: ArkEvent>(to eventType: Event.Type, _ listener: @escaping EventListener)
}
