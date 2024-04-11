protocol ArkExternalResources {
    associatedtype AudioEnum: ArkAudioEnum

    var audioEnum: AudioEnum { get }
}

struct NoExternalResources: ArkExternalResources {
    var audioEnum: NoAudio
}
