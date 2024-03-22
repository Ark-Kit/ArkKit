struct StopAudioHandler: AudioHandler {
    let event: ArkEventID
    let filename: any T

    func load(to audioplayer: AudioPlayer) {
        // No implementation: Stopping audio does not require preloading the audio file
    }

    func execute(_ audioplayer: AudioPlayer) {
        audioplayer.stop(filename)
    }
}
