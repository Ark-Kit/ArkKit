import XCTest
@testable import ArkKit

class ArkSKPhysicsBodyTests: XCTestCase {

    func testInitWithRectangle() {
        let body = ArkSKPhysicsBody(rectangleOf: CGSize(width: 100, height: 50))
        XCTAssertNotNil(body.node.physicsBody, "Physics body should not be nil.")
    }

    func testInitWithCircle() {
        let body = ArkSKPhysicsBody(circleOf: 30)
        XCTAssertNotNil(body.node.physicsBody, "Physics body should not be nil.")
    }

    func testPolygonInitWithValidVertices() {
        let vertices = [CGPoint(x: -50, y: -50), CGPoint(x: 50, y: -50), CGPoint(x: 50, y: 50), CGPoint(x: -50, y: 50)]
        let body = ArkSKPhysicsBody(polygonOf: vertices)
        XCTAssertNotNil(body.node.physicsBody, "Physics body should not be nil for a valid polygon.")
    }

    func testPropertyAccessorsAndMutators() {
        let body = ArkSKPhysicsBody(circleOf: 10)
        body.position = CGPoint(x: 10, y: 10)
        body.mass = 5.0
        body.velocity = CGVector(dx: 5, dy: 5)
        body.isDynamic = false
        body.affectedByGravity = false
        body.linearDamping = 0.5
        body.angularDamping = 0.5
        body.allowsRotation = false
        body.friction = 0.25
        body.restitution = 0.25
        body.categoryBitMask = 0x00000001
        body.collisionBitMask = 0x00000002
        body.contactTestBitMask = 0x00000004

        XCTAssertEqual(body.position, CGPoint(x: 10, y: 10))
        XCTAssertEqual(body.mass, 5.0, accuracy: 0.0001)
        XCTAssertEqual(body.velocity.dx, 5.0, accuracy: 0.0001)
        XCTAssertEqual(body.velocity.dy, 5.0, accuracy: 0.0001)
        XCTAssertFalse(body.isDynamic)
        XCTAssertFalse(body.affectedByGravity)
        XCTAssertEqual(body.linearDamping, 0.5, accuracy: 0.0001)
        XCTAssertEqual(body.angularDamping, 0.5, accuracy: 0.0001)
        XCTAssertFalse(body.allowsRotation)
        XCTAssertEqual(body.friction, 0.25, accuracy: 0.0001)
        XCTAssertEqual(body.restitution, 0.25, accuracy: 0.0001)
        XCTAssertEqual(body.categoryBitMask, 0x00000001)
        XCTAssertEqual(body.collisionBitMask, 0x00000002)
        XCTAssertEqual(body.contactTestBitMask, 0x00000004)
    }

    func testApplyImpulse() {
        let body = ArkSKPhysicsBody(circleOf: 20)
        let impulse = CGVector(dx: 10, dy: 10)
        body.applyImpulse(impulse)
    }

    func testApplyAngularImpulse() {
        let body = ArkSKPhysicsBody(circleOf: 20)
        let impulse: CGFloat = 5.0
        body.applyAngularImpulse(impulse)
    }

    func testEqualityAndHashable() {
        let body1 = ArkSKPhysicsBody(circleOf: 20)
        let body2 = body1
        let body3 = ArkSKPhysicsBody(circleOf: 20)

        XCTAssertEqual(body1, body2,
                       "Same instances should be equal")
        XCTAssertNotEqual(body1, body3,
                          "Different instances with same properties should not be equal due to node identity")
    }
}
