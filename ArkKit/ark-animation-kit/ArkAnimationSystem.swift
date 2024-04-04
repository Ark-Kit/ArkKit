import Foundation

/**
 *  A system which updates all running animation instances in ArkECS after the given delta.
 */
class ArkAnimationSystem: UpdateSystem {
    var active: Bool

    init(active: Bool = true) {
        self.active = active
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        let animationComponents = arkECS.getEntities(with: [ArkAnimationsComponent.self])

        for entity in animationComponents {
            guard let animationsComponent = arkECS.getComponent(ofType: ArkAnimationsComponent.self, for: entity) else {
                return
            }

            for animationInstance in animationsComponent.animations {
                animationInstance.advance(by: deltaTime)
            }
        }
    }
}
