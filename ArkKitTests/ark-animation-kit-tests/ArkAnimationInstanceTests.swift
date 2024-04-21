import XCTest
@testable import ArkKit

final class ArkAnimationInstanceTests: XCTestCase {

    func testInitialization() {
        let animation = ArkAnimation<String>().keyframe("Frame1", duration: 1.0)
        let animationInstance = ArkAnimationInstance(animation: animation)

        XCTAssertTrue(animationInstance.isPlaying)
        XCTAssertEqual(animationInstance.currentFrame.value, "Frame1")
        XCTAssertFalse(animationInstance.shouldDestroy)
    }

    func testPlayPauseStop() {
        var animationInstance = ArkAnimationInstance(
            animation: ArkAnimation<String>().keyframe("Frame1", duration: 1.0),
            isPlaying: false
        )

        animationInstance.play()
        XCTAssertTrue(animationInstance.isPlaying)

        animationInstance.pause()
        XCTAssertFalse(animationInstance.isPlaying)

        animationInstance.stop()
        XCTAssertTrue(animationInstance.shouldDestroy)
    }

    func testAdvanceThroughKeyframes() {
        let animation = ArkAnimation<Double>()
            .keyframe(0.0, duration: 1.0)
            .keyframe(10.0, duration: 1.0)
            .keyframe(20.0, duration: 1.0)

        var animationInstance = ArkAnimationInstance(animation: animation)

        animationInstance.advance(by: 0.5)
        XCTAssertEqual(animationInstance.currentFrame.value, 0.0)

        animationInstance.advance(by: 0.5)
        XCTAssertEqual(animationInstance.currentFrame.value, 10.0)

        animationInstance.advance(by: 1.0)
        XCTAssertEqual(animationInstance.currentFrame.value, 20.0)
    }
}
