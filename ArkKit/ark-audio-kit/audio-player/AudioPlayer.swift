protocol AudioPlayer {
    typealias T = RawRepresentable<String>

    func loadAudio(_ filename: any T, numberOfLoops: Int)
    func play(_ filename: any T)
    func stop(_ filename: any T)
}
