import Foundation

/**
 * Represents an animation blueprint with a set of keyframes.
 */
struct ArkAnimation<T> {
    struct Keyframe {
        let value: T
        let offset: TimeInterval
        let duration: TimeInterval
    }

    private (set) var keyframes: [Keyframe]

    var duration: TimeInterval {
        if let lastFrame = keyframes.last {
            return lastFrame.offset + lastFrame.duration
        }

        return 0
    }

    mutating func keyframe(_ value: T, duration: Double) {
        let newOffset: Double = {
            if let previousFrame = keyframes.last {
                return previousFrame.offset + previousFrame.duration
            }

            return 0
        }()

        keyframes.append(Keyframe(value: value, offset: newOffset, duration: duration))
    }
}
