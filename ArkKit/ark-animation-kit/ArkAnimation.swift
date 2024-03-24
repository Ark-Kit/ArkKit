import Foundation

struct AnimationKeyframe<T: Equatable>: Equatable {
    let value: T
    let offset: TimeInterval
    let duration: TimeInterval
}

protocol Animation<T> {
    associatedtype T: Equatable

    var keyframes: [AnimationKeyframe<T>] { get }
    var duration: TimeInterval { get }
}

/**
 * Represents an animation blueprint with a set of keyframes.
 */
struct ArkAnimation<T>: Animation where T: Equatable {
    private (set) var keyframes: [AnimationKeyframe<T>]

    init() {
        self.keyframes = []
    }

    var duration: TimeInterval {
        if let lastFrame = keyframes.last {
            return lastFrame.offset + lastFrame.duration
        }

        return 0
    }

    func keyframe(_ value: T, duration: Double) -> Self {
        let newOffset: Double = {
            if let previousFrame = keyframes.last {
                return previousFrame.offset + previousFrame.duration
            }

            return 0
        }()

        var newSelf = self
        newSelf.keyframes.append(AnimationKeyframe(value: value, offset: newOffset, duration: duration))
        return newSelf
    }
}
