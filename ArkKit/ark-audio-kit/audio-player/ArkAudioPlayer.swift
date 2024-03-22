import AVFoundation

class ArkAudioPlayer: AudioPlayer {
    var audioplayers: [String: AVAudioPlayer] = [:]

    func loadAudio(_ filename: any T, numberOfLoops: Int) {
        guard let match = validateFilenameRegex(filename.rawValue) else {
            assertionFailure("Invalid audio file name: \(filename.rawValue)")
            return
        }

        let resource = String(match.1)
        let ext = String(match.2)

        guard let url = getResourceUrl(resource: resource, ext: ext) else {
            assertionFailure("Audio file \(resource).\(ext) could not be found!")
            return
        }

        guard let player = getAudioPlayer(url: url, numberOfLoops: numberOfLoops) else {
            assertionFailure("Audio player could not be instantiated!")
            return
        }

        audioplayers[filename.rawValue] = player
    }

    func play(_ filename: any T) {
        guard let audioplayer = audioplayers[filename.rawValue] else {
            assertionFailure("Playing non-existent audio file: \(filename.rawValue)")
            return
        }
        truncateAndPlay(audioplayer)
    }

    func stop(_ filename: any T) {
        guard let audioplayer = audioplayers[filename.rawValue] else {
            assertionFailure("Stopping non-existent audio file: \(filename.rawValue)")
            return
        }
        audioplayer.stop()
    }
}

// MARK: Helpers
extension ArkAudioPlayer {
    private func validateFilenameRegex(_ filename: String)
        // swiftlint:disable:next large_tuple
        -> Regex<Regex<(Substring, Substring, Substring)>.RegexOutput>.Match? {
        let filenameRegex = /([\w,\s-]+)\.([A-Za-z0-9]+)/
        return filename.firstMatch(of: filenameRegex)
    }

    private func getResourceUrl(resource: String, ext: String) -> URL? {
        Bundle.main.url(forResource: resource, withExtension: ext)
    }

    private func getAudioPlayer(url: URL, numberOfLoops: Int) -> AVAudioPlayer? {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = numberOfLoops
            player.prepareToPlay()
            return player
        } catch {
            // No implementation
        }
        return nil
    }

    private func truncateAndPlay(_ audioplayer: AVAudioPlayer) {
        audioplayer.currentTime = 0
        audioplayer.play()
    }
}
