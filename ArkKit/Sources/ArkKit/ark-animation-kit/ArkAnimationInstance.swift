import Foundation

public typealias UpdateDelegate<T: Equatable> = (any AnimationInstance<T>) -> Void
public typealias CompleteDelegate<T: Equatable> = (any AnimationInstance<T>) -> Void

public enum AnimationStatus {
    case playing
    case complete
}

public protocol AnimationInstance<T>: AnyObject where T: Equatable {
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
    public func play() {
        isPlaying = true
    }

    public func pause() {
        isPlaying = false
    }

    public func stop() {
        shouldDestroy = true
    }

    public func advance(by delta: TimeInterval) {
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
    public var value: T {
        let currentFrameValue = currentFrame.value
        let nextFrameIndex = min(currentFrameIndex + 1, animation.keyframes.count - 1)
        let nextFrameValue = animation.keyframes[nextFrameIndex].value

        return currentFrameValue + (nextFrameValue - currentFrameValue) * T(elapsedDelta / animation.duration)
    }
}

/**
 * Represents a running animation instance as an ArkECS component.
 */
public class ArkAnimationInstance<T>: AnimationInstance where T: Equatable {
    public var isPlaying: Bool
    public let animation: ArkAnimation<T>
    public var elapsedDelta: TimeInterval
    public var updateDelegate: UpdateDelegate<T>?
    public var keyframeUpdateDelegate: UpdateDelegate<T>?
    public var completeDelegate: CompleteDelegate<T>?

    public var shouldDestroy = false

    public var status: AnimationStatus {
        if elapsedDelta > animation.duration * Double(animation.runCount) && !animation.isLooping {
            return .complete
        }

        return .playing
    }

    public var currentFrame: AnimationKeyframe<T> {
        animation.keyframes[currentFrameIndex]
    }

    public var currentFrameIndex: Int {
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

    public func onUpdate(_ delegate: @escaping UpdateDelegate<T>) -> Self {
        self.updateDelegate = delegate
        return self
    }

    public func onKeyframeUpdate(_ delegate: @escaping UpdateDelegate<T>) -> Self {
        self.keyframeUpdateDelegate = delegate
        return self
    }

    public func onComplete(_ delegate: @escaping CompleteDelegate<T>) -> Self {
        self.completeDelegate = delegate
        return self
    }
}

extension ArkAnimation {
    public func toInstance() -> ArkAnimationInstance<T> {
        ArkAnimationInstance(animation: self)
    }
}
