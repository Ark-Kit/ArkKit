import Foundation

class ArkAudioContext<AudioEnum: ArkAudioEnum>: AudioContext {
    var soundPlayers: [AnySound: SoundPlayer] = [:]
    var soundMapping: [AudioEnum: any Sound] = [:]

    /// Loads the given soundMapping and overwrites the previous soundMapping (if any).
    func load(_ soundMapping: [AudioEnum: any Sound]) {
        var soundPlayers: [AnySound: SoundPlayer] = [:]

        soundMapping.forEach { _, sound in
            let wrappedSound = AnySound(sound)
            soundPlayers[wrappedSound] = SoundPlayer(sound)
        }

        self.soundPlayers = soundPlayers
        self.soundMapping = soundMapping
    }

    func play(_ audio: AudioEnum, audioPlayerId: UUID?) {
        guard let sound = soundMapping[audio] else {
            assertionFailure("Play error: soundMapping does not contain corresponding sound entry for \(audio)")
            return
        }

        guard let soundPlayer = soundPlayers[AnySound(sound)] else {
            assertionFailure("Play error: soundPlayer does not exist for sound \(sound)")
            return
        }

        if let audioPlayerId = audioPlayerId {
            soundPlayer.play(withId: audioPlayerId)
            return
        }

        soundPlayer.play()
    }

    func stop(_ audio: AudioEnum, audioPlayerId: UUID?) {
        guard let sound = soundMapping[audio] else {
            assertionFailure("Stop error: soundMapping does not contain corresponding sound entry for \(audio)")
            return
        }

        guard let soundPlayer = soundPlayers[AnySound(sound)] else {
            assertionFailure("Stop error: soundPlayer does not exist for sound \(sound)")
            return
        }

        if let audioPlayerId = audioPlayerId {
            soundPlayer.stop(audioPlayerId)
            return
        }

        soundPlayer.stop()
    }
}
