import Foundation
@testable import ArkKit

class MockAudioContext: AudioContext {
    func stop<S>(_ sound: S, playerId: UUID?) where S: ArkKit.Sound {
    }

    func play<S>(_ sound: S, playerId: UUID?) where S: ArkKit.Sound {
    }
}
