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
    var isLooping: Bool { get }
    var runCount: Int { get }
}

/**
 * Represents an animation blueprint with a set of keyframes.
 */
struct ArkAnimation<T>: Animation where T: Equatable {
    private (set) var keyframes: [AnimationKeyframe<T>]
    private (set) var isLooping: Bool
    private (set) var runCount: Int

    init() {
        self.keyframes = []
        self.isLooping = false
        self.runCount = 1
    }

    /**
     *  The total duration of the animation.
     */
    var duration: TimeInterval {
        if let lastFrame = keyframes.last {
            return lastFrame.offset + lastFrame.duration
        }

        return 0
    }

    /**
     *  Adds a keyframe to the animation with a given value and duration.
     */
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

    /**
     *  Sets the animation to run a given number of times. Should only be called after all keyframes are added.
     */
    func `repeat`(times runCount: Int) -> Self {
        assert(runCount > 0, "Repeat count must be greater than 0")
        var newSelf = self
        newSelf.runCount = runCount
        return newSelf
    }

    /**
     *  Repeats the animation indefinitely.
     */
    func loop() -> Self {
        var newSelf = self
        newSelf.isLooping = true
        return newSelf
    }

    /**
     *  Sets whether the animation should loop indefinitely.
     */
    func loop(_ value: Bool) -> Self {
        var newSelf = self
        newSelf.isLooping = value
        return newSelf
    }

    /**
     *  Returns a new animation with the keyframes in reverse order.
     */
    func reverse() -> Self {
        var newSelf = self
        newSelf.keyframes.reverse()
        return newSelf
    }
}
