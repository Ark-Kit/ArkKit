import XCTest
import CoreGraphics
@testable import ArkKit

final class PhysicsComponentTests: XCTestCase {

    func testInitializationWithCircle() {
        let physicsComponent = PhysicsComponent(
            shape: .circle,
            radius: 10.0,
            categoryBitMask: 1,
            collisionBitMask: 2,
            contactTestBitMask: 3
        )

        XCTAssertEqual(physicsComponent.shape, .circle)
        XCTAssertEqual(physicsComponent.radius, 10.0)
        XCTAssertNil(physicsComponent.size)
        XCTAssertEqual(physicsComponent.categoryBitMask, 1)
        XCTAssertEqual(physicsComponent.collisionBitMask, 2)
        XCTAssertEqual(physicsComponent.contactTestBitMask, 3)
    }

    func testInitializationWithRectangle() {
        let size = CGSize(width: 100.0, height: 50.0)
        let physicsComponent = PhysicsComponent(
            shape: .rectangle,
            size: size,
            categoryBitMask: 1,
            collisionBitMask: 2,
            contactTestBitMask: 3
        )

        XCTAssertEqual(physicsComponent.shape, .rectangle)
        XCTAssertEqual(physicsComponent.size, size)
        XCTAssertNil(physicsComponent.radius)
    }

    func testInitializationWithPolygon() {
        let vertices = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
        let physicsComponent = PhysicsComponent(
            shape: .polygon,
            vertices: vertices,
            categoryBitMask: 1,
            collisionBitMask: 2,
            contactTestBitMask: 3
        )

        XCTAssertEqual(physicsComponent.shape, .polygon)
        XCTAssertEqual(physicsComponent.vertices, vertices)
        XCTAssertNil(physicsComponent.radius)
        XCTAssertNil(physicsComponent.size)
    }

    func testVelocityAndImpulse() {
        var physicsComponent = PhysicsComponent(
            shape: .circle,
            categoryBitMask: 1,
            collisionBitMask: 2,
            contactTestBitMask: 3
        )

        let impulse = CGVector(dx: 10.0, dy: 15.0)
        physicsComponent.impulse = impulse

        XCTAssertEqual(physicsComponent.impulse, impulse)
        XCTAssertEqual(physicsComponent.velocity, .zero)
    }
}
