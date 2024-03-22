struct PlayAudioHandler: AudioHandler {
    let event: ArkEventID
    let filename: any T
    let numberOfLoops: Int

    func load(to audioplayer: AudioPlayer) {
        audioplayer.loadAudio(filename, numberOfLoops: numberOfLoops)
    }

    func execute(_ audioplayer: AudioPlayer) {
        audioplayer.play(filename)
    }
}
