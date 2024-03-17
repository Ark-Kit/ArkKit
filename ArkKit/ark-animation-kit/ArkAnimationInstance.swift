import Foundation

/**
 * Represents a running animation instance as an ArkECS component.
 */
struct ArkAnimationInstance<T>: Component {
    enum Status {
        case playing
        case complete
    }

    let animation: ArkAnimation<T>
    var elapsedDelta: TimeInterval

    var status: Status {
        if elapsedDelta > animation.duration {
            return .complete
        }

        return .playing
    }

    var currentFrame: ArkAnimation<T>.Keyframe {
        animation.keyframes.first(where: { keyframe in
            keyframe.offset >= elapsedDelta && keyframe.offset + keyframe.duration < elapsedDelta
        }) ?? animation.keyframes.last!
    }

    init(animation: ArkAnimation<T>, elapsedDelta: Double = 0) {
        self.animation = animation
        self.elapsedDelta = elapsedDelta
        assert(!self.animation.keyframes.isEmpty, "Animation keyframes cannot be empty")
    }
}

extension ArkAnimation {
    func toInstance() -> ArkAnimationInstance<T> {
        ArkAnimationInstance(animation: self)
    }
}
