import Foundation

class ArkUpdateSystem: UpdateSystem {
    var active: Bool
    let action: any Action<TimeInterval>
    let context: ArkActionContext

    init(action: any Action<TimeInterval>,
         context: ArkActionContext,
         active: Bool = true) {

        self.active = active
        self.action = action
        self.context = context
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        action.execute(deltaTime, context: context)
    }
}
