@testable import ArkKit
import Foundation

class MockNetworkService: ArkNetworkService {
    var sentData: Data?

    required init(serviceName: String = "mock") {
        super.init(serviceName: serviceName)
    }

    override func sendData(data: Data) {
        sentData = data
        super.sendData(data: data)
    }

    override func sendData(_ data: Data, to peerName: String) {
        sentData = data
        super.sendData(data, to: peerName)
    }

    override func disconnect() { }
}
