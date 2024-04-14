import Foundation

protocol ArkNetworkProtocol {
    var delegate: ArkNetworkDelegate? { get set }
    var deviceID: String { get }
    var serviceName: String { get }

    init(serviceName: String)
    func sendData(data: Data)
    func sendData(_ data: Data, to peerName: String)
}
