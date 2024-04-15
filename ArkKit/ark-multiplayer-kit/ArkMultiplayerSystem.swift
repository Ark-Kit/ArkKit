import Foundation

class ArkMultiplayerSystem: UpdateSystem {
    let multiplayerManager: ArkMultiplayerManager
    var active: Bool

    init(multiplayerManager: ArkMultiplayerManager) {
        self.multiplayerManager = multiplayerManager
        self.active = true
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        multiplayerManager.sendECS()
    }
}
