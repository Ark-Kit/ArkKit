import XCTest
@testable import ArkKit

class MockRootView: AbstractRootView {
    var abstractView: View
    init() {
        self.abstractView = 1
        self.size = CGSize(width: 0, height: 0)
    }
    func pushView(_ view: any ArkKit.AbstractView<View>, animated: Bool) {
    }

    var size: CGSize

    typealias View = Any
}

class ArkTests: XCTestCase {
    func testArkInit() {
        let mockRootView = MockRootView()
        let blueprint = ArkBlueprint<NoExternalResources>(frameWidth: 0, frameHeight: 0)
        let ark = Ark(rootView: mockRootView, blueprint: blueprint)

        XCTAssertNotNil(ark)
    }

    func testArkStart() {
        let mockRootView = MockRootView()
        let blueprint = ArkBlueprint<NoExternalResources>(frameWidth: 0, frameHeight: 0)
        let ark = Ark(rootView: mockRootView, blueprint: blueprint)
        ark.start()
        XCTAssertNotNil(ark.gameLoop)
    }

    func testArkFinish() {
        let mockRootView = MockRootView()
        let blueprint = ArkBlueprint<NoExternalResources>(frameWidth: 0, frameHeight: 0)
        let ark = Ark(rootView: mockRootView, blueprint: blueprint)
        ark.finish()
        XCTAssertNil(ark.gameLoop)
    }

    func testArkStartWithNetworkableBlueprintHost() {
        let mockRootView = MockRootView()
        let blueprint = ArkBlueprint<NoExternalResources>(frameWidth: 0, frameHeight: 0)
            .supportNetworkMultiPlayer(roomName: "Test", numberOfPlayers: 1)
            .setRole(.host)
        let ark = Ark(rootView: mockRootView, blueprint: blueprint)
        ark.start()
        XCTAssertNotNil(ark.gameLoop)
        XCTAssertNotNil(ark.networkService)
        ark.finish()
    }

    func testArkStartWithNetworkableBlueprintParticipant() {
        let mockRootView = MockRootView()
        let blueprint = ArkBlueprint<NoExternalResources>(frameWidth: 0, frameHeight: 0)
            .supportNetworkMultiPlayer(roomName: "Test", numberOfPlayers: 1)
            .setRole(.participant)
        let ark = Ark(rootView: mockRootView, blueprint: blueprint)
        ark.start()
        XCTAssertNotNil(ark.gameLoop)
        XCTAssertNotNil(ark.networkService)
        ark.finish()
    }

}
