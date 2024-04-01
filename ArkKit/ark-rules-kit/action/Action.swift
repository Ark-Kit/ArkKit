protocol Action<Data> {
    associatedtype Data
    var priority: Int { get }

    func execute(_ data: Data, context: ArkActionContext)
}

struct ArkEventAction<Event: ArkEvent>: Action {
    let callback: ActionCallback<Event>
    let priority: Int

    init(callback: @escaping ActionCallback<Event>, priority: Int = 0) {
        self.callback = callback
        self.priority = priority
    }
    func execute(_ data: Event,
                 context: ArkActionContext) {
        callback(data, context)
    }
}

struct ArkTickAction: Action {
    typealias DeltaTime = Double

    let callback: UpdateActionCallback
    let priority: Int

    init(callback: @escaping UpdateActionCallback, priority: Int = 0) {
        self.callback = callback
        self.priority = priority
    }

    func execute(_ data: DeltaTime,
                 context: ArkActionContext) {
        callback(data, context)
    }
}

typealias ActionCallback<Event: ArkEvent> = (Event, ArkActionContext) -> Void
typealias UpdateActionCallback = (Double, ArkActionContext) -> Void
