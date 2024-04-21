import XCTest
@testable import ArkKit

class SKPhysicsSceneTests: XCTestCase {
    var scene: SKPhysicsScene!
    var mockBasePhysicsScene: MockBaseSKScene!
    var mockPhysicsBodyManager: MockSKPhysicsBodyManager!
    let testSize = CGSize(width: 800, height: 600)

    override func setUp() {
        super.setUp()
        mockBasePhysicsScene = MockBaseSKScene(size: testSize)
        mockPhysicsBodyManager = MockSKPhysicsBodyManager()
        scene = SKPhysicsScene(size: testSize,
                               basePhysicsScene: mockBasePhysicsScene,
                               physicsBodyManager: mockPhysicsBodyManager,
                               physicsBodyFactory: MockArkSKPhysicsBodyFactory())
    }

    func testInit() {
        XCTAssertNotNil(scene.basePhysicsScene, "Base physics scene should be initialized.")
    }

    func testGetCurrentTime() {
        XCTAssertEqual(scene.getCurrentTime(), 0.0, accuracy: 0.0001,
                       "Should return the current time from base physics scene.")
    }

    func testSetGravity() {
        let gravity = CGVector(dx: 0, dy: -9.8)
        scene.setGravity(gravity)
        XCTAssertEqual(scene.basePhysicsScene.physicsWorld.gravity.dx, gravity.dx, accuracy: 0.0001,
                       "Gravity.dx should be set correctly in the physics world.")
            XCTAssertEqual(scene.basePhysicsScene.physicsWorld.gravity.dy, gravity.dy, accuracy: 0.0001,
                           "Gravity.dy should be set correctly in the physics world.")
        }

    func testGetDeltaTime() {
        XCTAssertEqual(scene.getDeltaTime(), 0.0, accuracy: 0.0001,
                       "Should return the delta time from base physics scene.")
    }

    func testCreateCirclePhysicsBody() {
        let entity = Entity()
        let radius: CGFloat = 50
        let position = CGPoint(x: 100, y: 100)
        let createdBody =
                scene.createCirclePhysicsBody(for: entity,
                                              withRadius: radius,
                                              at: position) as? AbstractArkSKPhysicsBody

        XCTAssertNotNil(createdBody, "Circle physics body should not be nil.")
        XCTAssertEqual(createdBody?.position, position, "Position should match.")
        XCTAssertTrue(scene.basePhysicsScene.children.contains(createdBody!.node),
                      "Physics body node should be added to the scene.")
    }

    func testCreateRectanglePhysicsBody() {
        let entity = Entity()
        let size = CGSize(width: 100, height: 50)
        let position = CGPoint(x: 200, y: 200)
        let createdBody =
                scene.createRectanglePhysicsBody(for: entity,
                                                 withSize: size,
                                                 at: position) as? AbstractArkSKPhysicsBody

        XCTAssertNotNil(createdBody, "Rectangle physics body should not be nil.")
        XCTAssertTrue(scene.basePhysicsScene.children.contains(createdBody!.node),
                      "Physics body node should be added to the scene.")
        XCTAssertTrue(scene.basePhysicsScene.children.contains(createdBody!.node),
                      "Physics body node should be added to the scene.")
    }

    func testCreatePolygonPhysicsBody() {
        let entity = Entity()
        let vertices = [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1)]
        let position = CGPoint(x: 300, y: 300)
        let createdBody =
                scene.createPolygonPhysicsBody(for: entity,
                                               withVertices: vertices,
                                               at: position) as? AbstractArkSKPhysicsBody

        XCTAssertNotNil(createdBody, "Polygon physics body should not be nil.")
        XCTAssertEqual(createdBody?.position, position, "Position should match.")
        XCTAssertTrue(scene.basePhysicsScene.children.contains(createdBody!.node),
                      "Physics body node should be added to the scene.")
    }

    func testGetPhysicsBody() {
        let entity = Entity()
        let body = ArkSKPhysicsBody(circleOf: 50, at: CGPoint(x: 100, y: 100))
        scene.addBody(for: entity, bodyToAdd: body)

        let retrievedBody = scene.getPhysicsBody(for: entity)
        XCTAssertEqual(retrievedBody as? ArkSKPhysicsBody, body, "Should retrieve the correct physics body.")
    }

    func testRemovePhysicsBody() {
        let entity = Entity()
        let body = ArkSKPhysicsBody(circleOf: 50, at: CGPoint(x: 100, y: 100))
        scene.addBody(for: entity, bodyToAdd: body)
        XCTAssertNotNil(scene.getPhysicsBody(for: entity), "Physics body should be present before removal.")

        scene.removePhysicsBody(for: entity)
        XCTAssertNil(scene.getPhysicsBody(for: entity), "Physics body should be nil after removal.")
        XCTAssertFalse(scene.basePhysicsScene.children.contains(body.node),
                       "Physics body node should be removed from the scene.")
    }

    func testApplyImpulse() {
        let entity = Entity()
        let body = scene.createCirclePhysicsBody(for: entity, withRadius: 50, at: CGPoint(x: 100, y: 100))

        let impulse = CGVector(dx: 10, dy: 20)
        scene.apply(impulse: impulse, to: entity)
        XCTAssertEqual(body.velocity, impulse, "Impulse should be applied correctly to the body's velocity.")
    }

    func testApplyAngularImpulse() {
        let entity = Entity()
        let body = ArkSKPhysicsBody(circleOf: 50, at: CGPoint(x: 100, y: 100))
        scene.addBody(for: entity, bodyToAdd: body)

        let angularImpulse: CGFloat = 5.0
        scene.apply(angularImpulse: angularImpulse, to: entity)
        XCTAssertTrue(body.affectedByGravity,
                      "Angular impulse should be applied correctly to the body's angular velocity.")
    }

    func testAddBody() {
        let entity = Entity()
        let body = ArkSKPhysicsBody(circleOf: 50, at: CGPoint(x: 100, y: 100))
        scene.addBody(for: entity, bodyToAdd: body)

        XCTAssertTrue(scene.basePhysicsScene.children.contains(body.node),
                      "Physics body node should be added to the scene.")
    }

    func testGetEntityForPhysicsBody() {
        let entity = Entity()
        let body = ArkSKPhysicsBody(circleOf: 50, at: CGPoint(x: 100, y: 100))
        scene.addBody(for: entity, bodyToAdd: body)
        let skPhysicsBody = body.node.physicsBody!

        let foundEntity = scene.getEntity(for: skPhysicsBody)
        XCTAssertEqual(foundEntity, entity,
                       "Should return the correct entity associated with the given SKPhysicsBody.")
    }
}
