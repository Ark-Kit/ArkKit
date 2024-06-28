public protocol ArkExternalResources {
    associatedtype AudioEnum: ArkAudioEnum

    var audioEnum: AudioEnum { get }
}

public struct NoExternalResources: ArkExternalResources {
    public var audioEnum: NoAudio

    public init() {
        self.audioEnum = .none
    }
}
