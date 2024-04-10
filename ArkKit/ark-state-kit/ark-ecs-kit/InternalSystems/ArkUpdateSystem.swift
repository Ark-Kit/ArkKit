import Foundation

class ArkUpdateSystem<ExternalResources: ArkExternalResources>: UpdateSystem {
    var active: Bool
    let action: any Action<TimeInterval, ExternalResources>
    let context: ArkActionContext<ExternalResources>

    init(action: any Action<TimeInterval, ExternalResources>,
         context: ArkActionContext<ExternalResources>,
         active: Bool = true) {

        self.active = active
        self.action = action
        self.context = context
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        action.execute(deltaTime, context: context)
    }
}
