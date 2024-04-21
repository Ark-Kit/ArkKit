import XCTest
import CoreGraphics

@testable import ArkKit

class JoystickRenderableComponentTests: XCTestCase {

    func testInitialization() {
        let joystick = JoystickRenderableComponent(radius: 50.0)

        XCTAssertEqual(joystick.radius, 50.0)
        XCTAssertTrue(joystick.isUserInteractionEnabled)
        XCTAssertNil(joystick.onPanStartDelegate)
        XCTAssertNil(joystick.onPanChangeDelegate)
        XCTAssertNil(joystick.onPanEndDelegate)
    }

    func testModifyPanDelegates() {
        var joystick = JoystickRenderableComponent(radius: 50.0)

        let startDelegate: PanEventDelegate = { _, _ in
        }

        let changeDelegate: PanEventDelegate = { _, _ in
        }

        let endDelegate: PanEventDelegate = { _, _ in
        }

        joystick = joystick.modify(
            onPanStartDelegate: startDelegate,
            onPanChangeDelegate: changeDelegate,
            onPanEndDelegate: endDelegate
        )

        XCTAssertNotNil(joystick.onPanStartDelegate)
        XCTAssertNotNil(joystick.onPanChangeDelegate)
        XCTAssertNotNil(joystick.onPanEndDelegate)
    }

    func testModify() {
        let joystick = JoystickRenderableComponent(radius: 50.0)
        var modifiedJoystick = joystick

        let center = CGPoint(x: 10.0, y: 20.0)

        modifiedJoystick = modifiedJoystick.modify(
            onPanStartDelegate: joystick.onPanStartDelegate,
            onPanChangeDelegate: joystick.onPanChangeDelegate,
            onPanEndDelegate: joystick.onPanEndDelegate
        )

        XCTAssertEqual(modifiedJoystick.radius, joystick.radius)
        XCTAssertEqual(modifiedJoystick.center, joystick.center)
        XCTAssertEqual(modifiedJoystick.renderLayer, joystick.renderLayer)
    }
}
