protocol Action<Event> {
    associatedtype Event: ArkEvent

    func execute(_ event: Event,
                 context: ArkActionContext)
}

struct ArkAction<Event: ArkEvent>: Action {
    let callback: ActionCallback<Event>

    func execute(_ event: Event,
                 context: ArkActionContext) {
        callback(event, context)
    }
}

typealias ActionCallback<Event: ArkEvent> = (Event, ArkActionContext) -> Void
