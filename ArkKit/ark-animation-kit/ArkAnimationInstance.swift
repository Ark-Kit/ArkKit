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
    var completeDelegate: CompleteDelegate<T>? { get }
    var status: AnimationStatus { get }
    var shouldDestroy: Bool { get set }
    var currentFrame: AnimationKeyframe<T> { get }
}

extension AnimationInstance {
    func markForDestroyal() {
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
                completeDelegate?(self)
            }
        }

        if hasAdvancedKeyframe {
            updateDelegate?(self)
        }
    }
}

/**
 * Represents a running animation instance as an ArkECS component.
 */
class ArkAnimationInstance<T>: AnimationInstance where T: Equatable {
    let animation: ArkAnimation<T>
    var elapsedDelta: TimeInterval
    var updateDelegate: UpdateDelegate<T>?
    var completeDelegate: CompleteDelegate<T>?

    var shouldDestroy = false

    var status: AnimationStatus {
        if elapsedDelta > animation.duration {
            return .complete
        }

        return .playing
    }

    var currentFrame: AnimationKeyframe<T> {
        animation.keyframes.first(where: { keyframe in
            elapsedDelta >= keyframe.offset && elapsedDelta < keyframe.offset + keyframe.duration
        }) ?? animation.keyframes.last!
    }

    init(animation: ArkAnimation<T>, elapsedDelta: Double = 0) {
        self.animation = animation
        self.elapsedDelta = elapsedDelta
        assert(!self.animation.keyframes.isEmpty, "Animation keyframes cannot be empty")
    }

    func onUpdate(_ delegate: @escaping UpdateDelegate<T>) -> Self {
        self.updateDelegate = delegate
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
