import XCTest
@testable import ArkKit

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

    func testArk_withBlueprintContextSetup_shouldStart() {
        let mockRootView = MockRootView()
        let blueprint = ArkBlueprint<NoExternalResources>(frameWidth: 0, frameHeight: 0)
            .setup { context in
                context.ecs.createEntity(with: [
                    ButtonRenderableComponent(width: 0, height: 0),
                    JoystickRenderableComponent(radius: 0),
                    CircleRenderableComponent(radius: 0),
                    RectRenderableComponent(width: 0, height: 0),
                    PolygonRenderableComponent(
                        points: [CGPoint(x: 0, y: 0)],
                        frame: CGRect(x: 0, y: 0, width: 0, height: 0)
                    ),
                    BitmapImageRenderableComponent(imageResourcePath: "test", width: 0, height: 0)
                ])
            }
        let ark = Ark(rootView: mockRootView, blueprint: blueprint)
        ark.start()
        XCTAssertNotNil(ark.gameLoop)
        ark.finish()
    }

}
