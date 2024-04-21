import XCTest
@testable import ArkKit

class AbstractArkPhysicsSceneTests: XCTestCase {
    var scene: MockArkPhysicsScene!
    var entity: Entity!
    var physicsBody: AbstractArkPhysicsBody!

    override func setUp() {
        super.setUp()
        scene = MockArkPhysicsScene()
        entity = Entity()
        physicsBody = scene.createCirclePhysicsBody(for: entity, withRadius: 20.0, at: .zero)
    }

    func testCreateCirclePhysicsBody() {
        let radius: CGFloat = 5.0
        let position = CGPoint(x: 100, y: 100)
        _ = scene.createCirclePhysicsBody(for: entity, withRadius: radius, at: position)
        XCTAssertNotNil(scene.getPhysicsBody(for: entity), "Physics body should be created and retrievable.")
    }

    func testApplyImpulse() {
        let impulse = CGVector(dx: 10, dy: 10)
        scene.apply(impulse: impulse, to: entity)
        XCTAssertEqual(physicsBody.velocity, impulse, "Impulse should be applied correctly to the body's velocity.")
    }

    func testSetGravity() {
        let gravity = CGVector(dx: 0, dy: -9.8)
        scene.setGravity(gravity)
    }
}
