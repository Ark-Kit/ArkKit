struct Once<Event: ArkEvent>: Action {
    private let callback: ActionCallback<Event>

    init(_ callback: @escaping ActionCallback<Event>) {
        self.callback = callback
    }

    func execute(_ event: Event, context: ArkActionContext) {
        callback(event, context)
    }
}
