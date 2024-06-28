import Foundation

protocol AbstractNetworkService: AnyObject {
    var subscriber: ArkNetworkSubscriberDelegate? { get set }
    var publisher: ArkNetworkPublisherDelegate? { get set }

    var deviceID: String { get }
    var serviceName: String { get }

    init(serviceName: String)
    func sendData(data: Data)
    func sendData(_ data: Data, to peerName: String)
    func disconnect()
}
