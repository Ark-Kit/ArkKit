struct Once: Action {
    private let callback: (ArkEvent, ArkEventContext, ArkECSContext) -> Void
    init(_ callback: @escaping (ArkEvent, ArkEventContext, ArkECSContext) -> Void) {
        self.callback = callback
    }
    func execute<Event: ArkEvent>(_ event: Event, eventContext: ArkEventContext, ecsContext: ArkECSContext) {
        callback(event, eventContext, ecsContext)
    }
}
