protocol Action<Event> {
    associatedtype Event = ArkEvent

    func execute(_ event: Event,
                 context: ArkContext)
}

typealias ActionCallback<Event: ArkEvent> = (Event, ArkContext) -> Void
