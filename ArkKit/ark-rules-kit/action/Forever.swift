struct Forever: Action {
    private let callback: (any ArkEvent, ArkEventContext, ArkECSContext) -> Void
    init(_ callback: @escaping (any ArkEvent, ArkEventContext, ArkECSContext) -> Void) {
        self.callback = callback
    }
    func execute<Event: ArkEvent>(_ event: Event, eventContext: ArkEventContext, ecsContext: ArkECSContext) {
        callback(event, eventContext, ecsContext)
        eventContext.subscribe(to: Event.id) { (nextEvent: any ArkEvent) -> Void in
            guard let castedEvent = nextEvent as? Event else {
                return
            }
            callback(castedEvent, eventContext, ecsContext)
        }
    }
}
