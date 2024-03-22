protocol AudioHandler {
    typealias T = RawRepresentable<String>
    var event: ArkEventID { get }
    var filename: any T { get }

    func load(to audioplayer: AudioPlayer)
    func execute(_ audioplayer: AudioPlayer)
}
