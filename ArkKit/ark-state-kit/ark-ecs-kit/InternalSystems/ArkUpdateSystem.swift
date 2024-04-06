import Foundation

class ArkUpdateSystem<AudioEnum: ArkAudioEnum>: UpdateSystem {
    var active: Bool
    let action: any Action<TimeInterval, AudioEnum>
    let context: ArkActionContext<AudioEnum>

    init(action: any Action<TimeInterval, AudioEnum>,
         context: ArkActionContext<AudioEnum>,
         active: Bool = true) {

        self.active = active
        self.action = action
        self.context = context
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        action.execute(deltaTime, context: context)
    }
}
