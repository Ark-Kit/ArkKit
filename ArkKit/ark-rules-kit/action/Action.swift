protocol Action<Event> {
    associatedtype Event = ArkEvent

    func execute(_ event: Event,
                 context: ArkActionContext)
}

typealias ActionCallback<Event: ArkEvent> = (Event, ArkActionContext) -> Void
