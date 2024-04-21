import XCTest
@testable import ArkKit

class ArkNetworkServiceTests: XCTestCase {
    var networkService: ArkNetworkService!

    override func setUp() {
        super.setUp()
        networkService = ArkNetworkService()
    }

    override func tearDown() {
        networkService.disconnect()
        networkService = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertEqual(networkService.serviceName, "Ark", "Service name should be set to default 'Ark'")
    }

}
