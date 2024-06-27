import Foundation
@testable import ArkKit

class MockAudioContext<AudioEnum: ArkAudioEnum>: AudioContext {
    func load(_ soundMapping: [AudioEnum: any ArkKit.Sound]) {}
    func play(_ audio: AudioEnum, audioPlayerId: UUID?) {}
    func stop(_ audio: AudioEnum, audioPlayerId: UUID?) {}
}
