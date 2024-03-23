struct Forever<Event: ArkEvent>: Action {
    private let callback: ActionCallback<Event>

    init(_ callback: @escaping ActionCallback<Event>) {
        self.callback = callback
    }

    func execute(_ event: Event, context: ArkActionContext) {
        callback(event, context)
        let nextForever = self
        context.events.subscribe(to: Event.id) { nextEvent in
            guard let castedEvent = nextEvent as? Event else {
                return
            }
            nextForever.execute(castedEvent, context: context)
        }
    }
}
