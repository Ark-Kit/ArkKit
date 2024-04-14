protocol Action<Data, ExternalResources> {
    associatedtype Data
    associatedtype ExternalResources: ArkExternalResources
    var priority: Int { get }

    func execute(_ data: Data, context: ArkActionContext<ExternalResources>)
}

struct ArkEventAction<Event: ArkEvent, ExternalResources: ArkExternalResources>: Action {
    let callback: ActionCallback<Event, ExternalResources>
    let priority: Int

    init(callback: @escaping ActionCallback<Event, ExternalResources>, priority: Int = 0) {
        self.callback = callback
        self.priority = priority
    }
    func execute(_ data: Event,
                 context: ArkActionContext<ExternalResources>) {
        callback(data, context)
    }
}

struct ArkTickAction<ExternalResources: ArkExternalResources>: Action {
    let callback: GameLoopActionCallback<ExternalResources>
    let priority: Int

    init(callback: @escaping GameLoopActionCallback<ExternalResources>, priority: Int = 0) {
        self.callback = callback
        self.priority = priority
    }

    func execute(_ data: ArkTimeFacade,
                 context: ArkActionContext<ExternalResources>) {
        callback(data, context)
    }
}

typealias ActionCallback<Event: ArkEvent, ExternalResources: ArkExternalResources> =
(Event, ArkActionContext<ExternalResources>) -> Void

typealias GameLoopActionCallback<ExternalResources: ArkExternalResources> =
(ArkTimeFacade, ArkActionContext<ExternalResources>) -> Void
