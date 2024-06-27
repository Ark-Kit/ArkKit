import XCTest
@testable import ArkKit

class ComponentRegistryTests: XCTestCase {

    func testDecodeRegisteredComponent() throws {
        let registry = ComponentRegistry.shared
        let positionComponent = PositionComponent(position: CGPoint(x: 100, y: 200))
        let jsonData = try JSONEncoder().encode(positionComponent)

        let component = try registry.decode(from: jsonData, typeName: "PositionComponent")
        XCTAssertNotNil(component, "Decoded PositionComponent should not be nil")
    }

    func testDecodeUnregisteredComponent() throws {
        let registry = ComponentRegistry.shared
        let jsonData = "{\"height\": 180, \"width\": 200}".data(using: .utf8)!

        let component = try registry.decode(from: jsonData, typeName: "UnregisteredComponent")
        XCTAssertNil(component, "Should return nil for unregistered components")
    }

    func testDecodingFailure() {
        let registry = ComponentRegistry.shared
        let invalidJsonData = "invalid json".data(using: .utf8)!

        XCTAssertThrowsError(try registry.decode(from: invalidJsonData, typeName: "PositionComponent")) { error in
            guard case DecodingError.dataCorrupted = error else {
                return XCTFail("Expected dataCorrupted error")
            }
        }
    }
}
