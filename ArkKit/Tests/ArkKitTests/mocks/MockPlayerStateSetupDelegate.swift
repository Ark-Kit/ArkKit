@testable import ArkKit

class MockPlayerStateSetupDelegate: ArkPlayerStateSetupDelegate {
    var setupPlayerId: Int?
    func setup(_ playerId: Int) {
        setupPlayerId = playerId
    }
}
