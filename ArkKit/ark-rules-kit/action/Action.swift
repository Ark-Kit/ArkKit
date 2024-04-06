protocol Action<Data, AudioEnum> {
    associatedtype Data
    associatedtype AudioEnum: ArkAudioEnum
    var priority: Int { get }

    func execute(_ data: Data, context: ArkActionContext<AudioEnum>)
}

struct ArkEventAction<Event: ArkEvent, AudioEnum: ArkAudioEnum>: Action {
    let callback: ActionCallback<Event, AudioEnum>
    let priority: Int

    init(callback: @escaping ActionCallback<Event, AudioEnum>, priority: Int = 0) {
        self.callback = callback
        self.priority = priority
    }
    func execute(_ data: Event,
                 context: ArkActionContext<AudioEnum>) {
        callback(data, context)
    }
}

struct ArkTickAction<AudioEnum: ArkAudioEnum>: Action {
    typealias DeltaTime = Double

    let callback: UpdateActionCallback<AudioEnum>
    let priority: Int

    init(callback: @escaping UpdateActionCallback<AudioEnum>, priority: Int = 0) {
        self.callback = callback
        self.priority = priority
    }

    func execute(_ data: DeltaTime,
                 context: ArkActionContext<AudioEnum>) {
        callback(data, context)
    }
}

typealias ActionCallback<Event: ArkEvent, AudioEnum: ArkAudioEnum> = (Event, ArkActionContext<AudioEnum>) -> Void
typealias UpdateActionCallback<AudioEnum: ArkAudioEnum> = (Double, ArkActionContext<AudioEnum>) -> Void
