import XCTest
import CoreGraphics

@testable import ArkKit

class ButtonRenderableComponentTests: XCTestCase {

    func testInitialization() {
        let button = ButtonRenderableComponent(width: 100.0, height: 50.0)

        XCTAssertEqual(button.width, 100.0)
        XCTAssertEqual(button.height, 50.0)
        XCTAssertEqual(button.isUserInteractionEnabled, true)
        XCTAssertNil(button.onTapDelegate)
    }

    func testLabel() {
        var button = ButtonRenderableComponent(width: 100.0, height: 50.0)

        button = button.label("Click Me", color: AbstractColor.black)
        XCTAssertEqual(button.buttonStyleConfig.labelMapping?.label, "Click Me")
        XCTAssertEqual(button.buttonStyleConfig.labelMapping?.color, AbstractColor.black)

        button = button.label("Press", color: AbstractColor.blue)
        XCTAssertEqual(button.buttonStyleConfig.labelMapping?.label, "Press")
        XCTAssertEqual(button.buttonStyleConfig.labelMapping?.color, AbstractColor.blue)
    }

    func testBackground() {
        var button = ButtonRenderableComponent(width: 100.0, height: 50.0)

        button = button.background(color: AbstractColor.green)
        XCTAssertEqual(button.buttonStyleConfig.backgroundColor, AbstractColor.green)

        button = button.background(color: AbstractColor.red)
        XCTAssertEqual(button.buttonStyleConfig.backgroundColor, AbstractColor.red)
    }

    func testBorderRadius() {
        var button = ButtonRenderableComponent(width: 100.0, height: 50.0)

        button = button.borderRadius(10.0)
        XCTAssertEqual(button.buttonStyleConfig.borderRadius, 10.0)

        button = button.borderRadius(20.0)
        XCTAssertEqual(button.buttonStyleConfig.borderRadius, 20.0)
    }

    func testBorderWidthAndColor() {
        var button = ButtonRenderableComponent(width: 100.0, height: 50.0)

        button = button.borderWidth(5.0).borderColor(AbstractColor.black)
        XCTAssertEqual(button.buttonStyleConfig.borderWidth, 5.0)
        XCTAssertEqual(button.buttonStyleConfig.borderColor, AbstractColor.black)

        button = button.borderWidth(3.0).borderColor(AbstractColor.blue)
        XCTAssertEqual(button.buttonStyleConfig.borderWidth, 3.0)
        XCTAssertEqual(button.buttonStyleConfig.borderColor, AbstractColor.blue)
    }

    func testPadding() {
        var button = ButtonRenderableComponent(width: 100.0, height: 50.0)

        button = button.padding(10.0)
        XCTAssertEqual(button.buttonStyleConfig.padding?[.top], 10.0)
        XCTAssertEqual(button.buttonStyleConfig.padding?[.bottom], 10.0)
        XCTAssertEqual(button.buttonStyleConfig.padding?[.left], 10.0)
        XCTAssertEqual(button.buttonStyleConfig.padding?[.right], 10.0)

        button = button.padding(top: 5.0, bottom: 15.0, left: 10.0, right: 20.0)
        XCTAssertEqual(button.buttonStyleConfig.padding?[.top], 5.0)
        XCTAssertEqual(button.buttonStyleConfig.padding?[.bottom], 15.0)
        XCTAssertEqual(button.buttonStyleConfig.padding?[.left], 10.0)
        XCTAssertEqual(button.buttonStyleConfig.padding?[.right], 20.0)
    }

    func testOnTapDelegate() {
        var button = ButtonRenderableComponent(width: 100.0, height: 50.0)

        let tapDelegate: TapDelegate = {
        }

        button = button.modify(onTapDelegate: tapDelegate)

        XCTAssertNotNil(button.onTapDelegate)
    }
}
