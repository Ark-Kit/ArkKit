import XCTest
@testable import ArkKit

final class ArkAnimationTests: XCTestCase {

    func testKeyframeAddition() {
        var animation = ArkAnimation<String>()
        animation = animation.keyframe("Frame1", duration: 1.0)

        XCTAssertEqual(animation.keyframes.count, 1)
        XCTAssertEqual(animation.keyframes.first?.value, "Frame1")
    }

    func testLoop() {
        var animation = ArkAnimation<String>().keyframe("Frame1", duration: 1.0)
        animation = animation.loop()

        XCTAssertTrue(animation.isLooping)
    }

    func testReverse() {
        var animation = ArkAnimation<String>()
            .keyframe("Frame1", duration: 1.0)
            .keyframe("Frame2", duration: 2.0)

        animation = animation.reverse()

        XCTAssertEqual(animation.keyframes.count, 2)
        XCTAssertEqual(animation.keyframes.first?.value, "Frame2")
        XCTAssertEqual(animation.keyframes.last?.value, "Frame1")
    }

    func testRepeat() {
        var animation = ArkAnimation<String>().keyframe("Frame1", duration: 1.0)
        animation = animation.repeat(times: 3)

        XCTAssertEqual(animation.runCount, 3)
    }
}
