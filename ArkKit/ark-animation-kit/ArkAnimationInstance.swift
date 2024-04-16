import Foundation

typealias UpdateDelegate<T: Equatable> = (any AnimationInstance<T>) -> Void
typealias CompleteDelegate<T: Equatable> = (any AnimationInstance<T>) -> Void

enum AnimationStatus {
    case playing
    case complete
}

protocol AnimationInstance<T>: AnyObject where T: Equatable {
    associatedtype T

    var animation: ArkAnimation<T> { get }
    var elapsedDelta: TimeInterval { get set }
    var updateDelegate: UpdateDelegate<T>? { get }
    var keyframeUpdateDelegate: UpdateDelegate<T>? { get }
    var completeDelegate: CompleteDelegate<T>? { get }
    var status: AnimationStatus { get }
    var shouldDestroy: Bool { get set }
    var currentFrame: AnimationKeyframe<T> { get }
    var currentFrameIndex: Int { get }
    var isPlaying: Bool { get set }
}

extension AnimationInstance {
    func play() {
        isPlaying = true
    }

    func pause() {
        isPlaying = false
    }

    func stop() {
        shouldDestroy = true
    }

    func advance(by delta: TimeInterval) {
        let wasComplete = status == .complete
        let previousKeyframe = currentFrame

        elapsedDelta += delta

        let currentFrame = self.currentFrame
        let hasAdvancedKeyframe = currentFrame != previousKeyframe

        if !wasComplete {
            if status == .complete {
                if !animation.isLooping {
                    stop()
                }
                completeDelegate?(self)
            }
        }

        if hasAdvancedKeyframe {
            keyframeUpdateDelegate?(self)
        }

        updateDelegate?(self)
    }
}

// extension where T is a number type
extension AnimationInstance where T: BinaryFloatingPoint {
    var value: T {
        let currentFrameValue = currentFrame.value
        let nextFrameIndex = min(currentFrameIndex + 1, animation.keyframes.count - 1)
        let nextFrameValue = animation.keyframes[nextFrameIndex].value

        return currentFrameValue + (nextFrameValue - currentFrameValue) * T(elapsedDelta / animation.duration)
    }
}

/**
 * Represents a running animation instance as an ArkECS component.
 */
class ArkAnimationInstance<T>: AnimationInstance where T: Equatable {
    var isPlaying: Bool
    let animation: ArkAnimation<T>
    var elapsedDelta: TimeInterval
    var updateDelegate: UpdateDelegate<T>?
    var keyframeUpdateDelegate: UpdateDelegate<T>?
    var completeDelegate: CompleteDelegate<T>?

    var shouldDestroy = false

    var status: AnimationStatus {
        if elapsedDelta > animation.duration * Double(animation.runCount) && !animation.isLooping {
            return .complete
        }

        return .playing
    }

    var currentFrame: AnimationKeyframe<T> {
        animation.keyframes[currentFrameIndex]
    }

    var currentFrameIndex: Int {
        let resolvedDelta = elapsedDelta.truncatingRemainder(dividingBy: animation.duration)
        return animation.keyframes.firstIndex(where: { keyframe in
            resolvedDelta >= keyframe.offset && resolvedDelta < keyframe.offset + keyframe.duration
        }) ?? animation.keyframes.count - 1
    }

    init(animation: ArkAnimation<T>, elapsedDelta: Double = 0, isPlaying: Bool = true) {
        self.animation = animation
        self.elapsedDelta = elapsedDelta
        self.isPlaying = isPlaying
        assert(!self.animation.keyframes.isEmpty, "Animation keyframes cannot be empty")
    }

    func onUpdate(_ delegate: @escaping UpdateDelegate<T>) -> Self {
        self.updateDelegate = delegate
        return self
    }

    func onKeyframeUpdate(_ delegate: @escaping UpdateDelegate<T>) -> Self {
        self.keyframeUpdateDelegate = delegate
        return self
    }

    func onComplete(_ delegate: @escaping CompleteDelegate<T>) -> Self {
        self.completeDelegate = delegate
        return self
    }
}

extension ArkAnimation {
    func toInstance() -> ArkAnimationInstance<T> {
        ArkAnimationInstance(animation: self)
    }
}
