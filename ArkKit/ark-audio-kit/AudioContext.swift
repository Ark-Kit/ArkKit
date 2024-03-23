import Foundation

protocol AudioContext {
    func play<S: Sound>(_ sound: S, playerId: UUID?)
    func stop<S: Sound>(_ sound: S, playerId: UUID?)
}

extension AudioContext {
    func play<S: Sound>(_ sound: S) {
        play(sound, playerId: nil)
    }

    func stop<S: Sound>(_ sound: S) {
        stop(sound, playerId: nil)
    }
}
