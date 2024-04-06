import AVFoundation

// Maintains a pool of preloaded audio players to handle multiple instances of the same sound playing.
class SoundPlayer: NSObject, AVAudioPlayerDelegate {
    let sound: any Sound
    var freeAudioPlayers: [AVAudioPlayer] // stack of 'free' audio players
    var currentlyPlaying: [UUID: AVAudioPlayer] = [:]

    init(_ sound: any Sound) {
        self.sound = sound
        self.freeAudioPlayers = []

        guard let audioPlayer = SoundPlayer.createAudioPlayer(for: sound) else {
            assertionFailure("Unable to create audio player!")
            return
        }

        self.freeAudioPlayers = [audioPlayer]
    }

    func play(withId id: UUID = UUID()) {
        guard let audioPlayer = getAudioPlayer() else {
            assertionFailure("Unable to get audio player!")
            return
        }

        audioPlayer.delegate = self

        currentlyPlaying[id] = audioPlayer
        audioPlayer.play()
    }

    /// Stops the audio player of this sound with id `id`.
    func stop(_ id: UUID) {
        guard let audioPlayer = currentlyPlaying[id] else {
            assertionFailure("No audio player with ID \(id) is currently playing!")
            return
        }

        audioPlayer.stop()
        audioPlayer.currentTime = 0 // reset timestamp

        currentlyPlaying[id] = nil
        freeAudioPlayers.append(audioPlayer)
    }

    /// Stops all audio players of this sound.
    func stop() {
        currentlyPlaying.forEach { _, audioPlayer in
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            freeAudioPlayers.append(audioPlayer)
        }
        currentlyPlaying = [:]
    }
}

// MARK: Override AVAudioPlayerDelegate
extension SoundPlayer {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("inside audioPlayerDidFinishPlaying")
        currentlyPlaying = currentlyPlaying.filter({ $0.1 != player })
        freeAudioPlayers.append(player)
    }
}

// MARK: Helpers
extension SoundPlayer {
    /// Maintains minimally one preloaded audio player that is free in `freeAudioPlayers`.
    private func getAudioPlayer() -> AVAudioPlayer? {
        guard let audioPlayer = freeAudioPlayers.popLast() else {
            assertionFailure("freeAudioPlayers should never be empty!")
            return nil
        }

        if freeAudioPlayers.isEmpty, let newAudioPlayer = SoundPlayer.createAudioPlayer(for: sound) {
            freeAudioPlayers.append(newAudioPlayer)
        }

        return audioPlayer
    }

    private static func createAudioPlayer<S: Sound>(for sound: S) -> AVAudioPlayer? {
        guard let url = getResourceUrl(resource: sound.filename, ext: sound.fileExtension) else {
            assertionFailure("Audio file \(sound.toString()) could not be found!")
            return nil
        }

        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url) else {
            assertionFailure("Unable to initialize a new AVAudioPlayer for \(url)")
            return nil
        }

        audioPlayer.numberOfLoops = sound.numberOfLoops
        audioPlayer.prepareToPlay()

        return audioPlayer
    }

    private static func getResourceUrl(resource: String, ext: String) -> URL? {
        Bundle.main.url(forResource: resource, withExtension: ext)
    }
}
