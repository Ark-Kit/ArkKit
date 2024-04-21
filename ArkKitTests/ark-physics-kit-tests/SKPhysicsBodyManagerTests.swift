import XCTest
@testable import ArkKit

class SKPhysicsBodyManagerTests: XCTestCase {
    var manager: SKPhysicsBodyManager!
    var dummyEntity: Entity!
    var dummyBody: ArkSKPhysicsBody!

    override func setUp() {
        super.setUp()
        manager = SKPhysicsBodyManager()
        dummyEntity = Entity()
        dummyBody = ArkSKPhysicsBody(circleOf: 10)
    }

    func testAddBody() {
        let added = manager.addBody(for: dummyEntity, body: dummyBody)
        XCTAssertTrue(added, "Should be able to add a new body.")
        XCTAssertEqual(manager.getEntity(for: dummyBody.node), dummyEntity)
    }

    func testRemoveBody() {
        _ = manager.addBody(for: dummyEntity, body: dummyBody)
        manager.removeBody(for: dummyEntity)

        XCTAssertNil(manager.getBody(for: dummyEntity), "Body should be removed.")
        XCTAssertNil(manager.getEntity(for: dummyBody.node), "Entity mapping should be cleared.")
    }

    func testApplyImpulseSuccessfully() {
        _ = manager.addBody(for: dummyEntity, body: dummyBody)
        let result = manager.applyImpulse(CGVector(dx: 10, dy: 20), to: dummyEntity)

        XCTAssertTrue(result, "Apply impulse should succeed.")
    }

    func testApplyImpulseFailsForNonexistentEntity() {
        let result = manager.applyImpulse(CGVector(dx: 10, dy: 20), to: dummyEntity)

        XCTAssertFalse(result, "Apply impulse should fail for nonexistent entity.")
    }

    func testApplyAngularImpulseSuccessfully() {
        _ = manager.addBody(for: dummyEntity, body: dummyBody)
        let result = manager.applyAngularImpulse(30, to: dummyEntity)

        XCTAssertTrue(result, "Apply angular impulse should succeed.")
    }

    func testApplyAngularImpulseFailsForNonexistentEntity() {
        let result = manager.applyAngularImpulse(30, to: dummyEntity)

        XCTAssertFalse(result, "Apply angular impulse should fail for nonexistent entity.")
    }
}
