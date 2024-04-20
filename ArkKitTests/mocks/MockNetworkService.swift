@testable import ArkKit
import Foundation

class MockNetworkService: AbstractNetworkService {
    var subscriber: ArkNetworkSubscriberDelegate?
    var publisher: ArkNetworkPublisherDelegate?

    var deviceID = "mockDevice"
    var serviceName: String

    required init(serviceName: String) {
        self.serviceName = serviceName
    }

    func sendData(data: Data) { }
    func sendData(_ data: Data, to peerName: String) { }
    func disconnect() { }
}
