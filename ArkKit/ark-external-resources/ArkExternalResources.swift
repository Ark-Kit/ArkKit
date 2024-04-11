protocol ArkExternalResources {
    associatedtype AudioEnum: ArkAudioEnum
    associatedtype ImageEnum: ArkImageEnum

    var audioEnum: AudioEnum { get }
    var imageEnum: ImageEnum { get }
}

struct NoExternalResources: ArkExternalResources {
    var audioEnum: NoAudio
    var imageEnum: NoImage
}
