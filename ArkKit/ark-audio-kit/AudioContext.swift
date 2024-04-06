import Foundation

protocol AudioContext<AudioEnum> {
    associatedtype AudioEnum where AudioEnum: RawRepresentable & Hashable

    func load(_ soundMapping: [AudioEnum: any Sound])
    func play(_ audio: AudioEnum, audioPlayerId: UUID?)
    func stop(_ audio: AudioEnum, audioPlayerId: UUID?)
}

extension AudioContext {
    func play(_ audio: AudioEnum) {
        play(audio, audioPlayerId: nil)
    }

    /// Stops all audioplayers for `audio`.
    func stop(_ audio: AudioEnum) {
        stop(audio, audioPlayerId: nil)
    }
}

typealias ArkAudioEnum = RawRepresentable & Hashable
