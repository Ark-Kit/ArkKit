import XCTest
@testable import ArkKit

class AbstractArkPhysicsBodyTests: XCTestCase {
    var physicsBody: MockArkSKPhysicsBody!

    override func setUp() {
        super.setUp()
        physicsBody = MockArkSKPhysicsBody()
    }

    func testPropertySettings() {
        physicsBody.mass = 10.0
        XCTAssertEqual(physicsBody.mass, 10.0, "Mass should be settable and match the expected value.")
    }

    func testApplyLinearImpulse() {
        let impulse = CGVector(dx: 15, dy: 20)
        physicsBody.applyImpulse(impulse)
        XCTAssertEqual(physicsBody.velocity, impulse, "Applied linear impulse should affect the velocity correctly.")
    }
}
