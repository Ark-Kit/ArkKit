protocol Action<Event> {
    associatedtype Event: ArkEvent
    var priority: Int { get }

    func execute(_ event: Event,
                 context: ArkActionContext)
}

struct ArkAction<Event: ArkEvent>: Action {
    let callback: ActionCallback<Event>
    let priority: Int

    init(callback: @escaping ActionCallback<Event>, priority: Int = 0) {
        self.callback = callback
        self.priority = priority
    }
    func execute(_ event: Event,
                 context: ArkActionContext) {
        callback(event, context)
    }
}

typealias ActionCallback<Event: ArkEvent> = (Event, ArkActionContext) -> Void
