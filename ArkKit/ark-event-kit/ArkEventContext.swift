protocol ArkEventContext {
    typealias EventListener = (any ArkEvent) -> Void

    func emit<Event: ArkEvent>(_ event: inout Event)
    func subscribe(to eventId: ArkEventID, _ listener: @escaping EventListener)
}
