import AVFoundation

class ArkAudioPlayer: NSObject, AudioContext, AVAudioPlayerDelegate {
    var audioplayers: [AnySound: [UUID: AVAudioPlayer]] = [:]

    func play<S: Sound>(_ sound: S, playerId: UUID?) {
        guard let player = createAudioPlayer(sound: sound, playerId: playerId) else {
            return
        }

        player.numberOfLoops = sound.numberOfLoops
        player.prepareToPlay()
        player.play()
    }

    func stop<S: Sound>(_ sound: S, playerId: UUID?) {
        let wrappedSound = AnySound(sound)
        guard let playerId = playerId else {
            return stop(wrappedSound)
        }

        guard let player = audioplayers[wrappedSound]?[playerId] else {
            assertionFailure("Audioplayer for sound \(sound.toString()) with playerId \(playerId) does not exist!")
            return
        }

        player.stop()
        audioplayers[wrappedSound] = audioplayers[wrappedSound]?.filter({ $0.1 != player })
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        for (key, value) in audioplayers {
            audioplayers[key] = value.filter({ $0.1 != player })
        }
    }
}

// MARK: Helpers
extension ArkAudioPlayer {
    /// Creates an audioplayer with the corresponding sound file and stores it under `audioplayers`.
    private func createAudioPlayer<S: Sound>(sound: S, playerId: UUID?) -> AVAudioPlayer? {
        guard let url = getResourceUrl(resource: sound.filename, ext: sound.fileExtension) else {
            assertionFailure("Audio file \(sound.toString()) could not be found!")
            return nil
        }

        let wrappedSound = AnySound(sound)

        if let playerId = playerId, let player = audioplayers[wrappedSound]?[playerId] {
            assertionFailure("Sound \(sound.toString()) with playerId \(playerId) has already been created!")
            player.stop()
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            let playerId = playerId ?? UUID()

            if audioplayers[wrappedSound] == nil {
                audioplayers[wrappedSound] = [:]
            }
            audioplayers[wrappedSound]?[playerId] = player

            return player
        } catch {
            // No implementation
        }
        return nil
    }

    private func getResourceUrl(resource: String, ext: String) -> URL? {
        Bundle.main.url(forResource: resource, withExtension: ext)
    }

    private func stop(_ sound: AnySound) {
        guard let players = audioplayers[sound] else {
            assertionFailure("No audioplayers exist for sound \(sound.toString())")
            return
        }
        for player in players.values {
            player.stop()
        }
        audioplayers[sound] = [:]
    }
}
