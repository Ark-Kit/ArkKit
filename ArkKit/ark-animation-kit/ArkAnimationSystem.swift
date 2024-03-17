import Foundation

/**
 *  A system which updates all running animation instances in ArkECS after the given delta.
 */
class ArkAnimationSystem: System {
    var active: Bool

    init(active: Bool = true) {
        self.active = active
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        let runningAnimations = arkECS.getEntities(with: [ArkAnimationInstance<Any>.self])

        for entity in runningAnimations {
            guard var animationState = arkECS.getComponent(ofType: ArkAnimationInstance<Any>.self, for: entity) else {
                return
            }

            animationState.elapsedDelta += deltaTime

            arkECS.upsertComponent(animationState, to: entity)
        }
    }
}
