import Foundation

public protocol AudioContext<AudioEnum> {
    associatedtype AudioEnum: ArkAudioEnum

    func load(_ soundMapping: [AudioEnum: any Sound])
    func play(_ audio: AudioEnum, audioPlayerId: UUID?)
    func stop(_ audio: AudioEnum, audioPlayerId: UUID?)
}

extension AudioContext {
    public func play(_ audio: AudioEnum) {
        play(audio, audioPlayerId: nil)
    }

    /// Stops all audioplayers for `audio`.
    public func stop(_ audio: AudioEnum) {
        stop(audio, audioPlayerId: nil)
    }
}
