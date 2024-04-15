import Foundation

protocol ArkMultiplayerContext {
    var playerNumber: Int { get }
    var serviceName: String { get set }
    var role: ArkPeerRole { get }
}
