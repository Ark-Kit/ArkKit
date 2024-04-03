import Foundation

/**
 *  A system which updates a StopWatchComponent instances in ArkECS after the given delta.
 */
class ArkTimeSystem: UpdateSystem {
    static let ARK_WORLD_TIME = "_ArkWorldTime"

    var active: Bool

    init(active: Bool = true) {
        self.active = active
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        let stopWatchEntities = arkECS.getEntities(with: [StopWatchComponent.self])
        for stopWatchEntity in stopWatchEntities {
            guard let stopWatchComponent = arkECS.getComponent(ofType: StopWatchComponent.self,
                                                               for: stopWatchEntity) else {
                continue
            }
            var newStopWatchComponent = stopWatchComponent
            newStopWatchComponent.currentTime += deltaTime
            arkECS.upsertComponent(newStopWatchComponent, to: stopWatchEntity)
        }
    }
}
