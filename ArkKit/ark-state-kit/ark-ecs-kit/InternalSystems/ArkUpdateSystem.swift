import Foundation

class ArkUpdateSystem<ExternalResources: ArkExternalResources>: UpdateSystem {
    var active: Bool
    let action: any Action<ArkTimeFacade, ExternalResources>
    let context: ArkActionContext<ExternalResources>

    var stopWatchEntity: Entity?

    init(action: any Action<ArkTimeFacade, ExternalResources>,
         context: ArkActionContext<ExternalResources>,
         active: Bool = true) {
        self.active = active
        self.action = action
        self.context = context

        self.stopWatchEntity = context.ecs
            .getEntities(with: [StopWatchComponent.self])
            .first
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        guard let stopWatchEntity = stopWatchEntity,
              let stopWatchComponent = arkECS.getComponent(ofType: StopWatchComponent.self, for: stopWatchEntity) else {
            return
        }
        let timeFacade = ArkTimeFacade(deltaTime: deltaTime, clockTimeInSecondsGame: stopWatchComponent.currentTime)
        action.execute(timeFacade, context: context)
    }
}

struct ArkTimeFacade {
    let deltaTime: TimeInterval
    let clockTimeInSecondsGame: Double
}
