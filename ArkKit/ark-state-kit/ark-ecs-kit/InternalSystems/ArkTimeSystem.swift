import Foundation

/**
 *  A system which updates a StopWatchComponent instances in ArkECS after the given delta.
 */
class ArkTimeSystem: System {
    var active: Bool
    
    init(active: Bool = true) {
        self.active = active
    }
    
    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        let stopWatchEntities = arkECS.getEntities(with: [StopWatchComponent.self])
        for stopWatchEntity in stopWatchEntities {
            guard let stopWatchComponent = arkECS.getComponent(ofType: StopWatchComponent.self, for: stopWatchEntity) else {
                return
            }
            stopWatchComponent.currentTime += deltaTime
            arkECS.upsertComponent(stopWatchComponent, to: stopWatchEntity)
        }
    }
}
