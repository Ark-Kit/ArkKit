import XCTest
@testable import ArkKit

final class ArkAnimationsComponentTests: XCTestCase {

    func testAddAnimation() {
        var animationsComponent = ArkAnimationsComponent()
        let animation = ArkAnimationInstance(animation: ArkAnimation<String>().keyframe("Frame1", duration: 1.0))

        animationsComponent.addAnimation(animation)

        XCTAssertEqual(animationsComponent.animations.count, 1)
        XCTAssertTrue(animationsComponent.animations.contains(where: { $0 === animation }))
    }

    func testRemoveAnimation() {
        var animationsComponent = ArkAnimationsComponent()
        let animation = ArkAnimationInstance(animation: ArkAnimation<String>().keyframe("Frame1", duration: 1.0))

        animationsComponent.addAnimation(animation)
        animationsComponent.removeAnimation(animation)

        XCTAssertEqual(animationsComponent.animations.count, 0)
        XCTAssertFalse(animationsComponent.animations.contains(where: { $0 === animation }))
    }
}
