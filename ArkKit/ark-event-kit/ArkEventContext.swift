protocol ArkEventContext {
    func emit(_ event: inout ArkEvent)
    func subscribe(to eventId: ArkEventID, listener: @escaping (ArkEvent) -> Void)
}
