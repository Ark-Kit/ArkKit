import XCTest
import CoreGraphics

@testable import ArkKit

class CircleRenderableComponentTests: XCTestCase {

    func testInitialization() {
        let fillColor = AbstractColor.red
        let strokeColor = AbstractColor.blue
        let circle = CircleRenderableComponent(
            radius: 50.0,
            fillInfo: ShapeFillInfo(color: fillColor),
            strokeInfo: ShapeStrokeInfo(lineWidth: 2.0, color: strokeColor),
            labelInfo: ShapeLabelInfo(text: "Circle", color: .black, size: 14)
        )

        XCTAssertEqual(circle.radius, 50.0)
        XCTAssertEqual(circle.fillInfo?.color, fillColor)
        XCTAssertEqual(circle.strokeInfo?.lineWidth, 2.0)
        XCTAssertEqual(circle.strokeInfo?.color, strokeColor)
        XCTAssertEqual(circle.labelInfo?.text, "Circle")
        XCTAssertEqual(circle.labelInfo?.color, AbstractColor.black)
        XCTAssertEqual(circle.labelInfo?.size, 14)
    }

    func testFillAndStroke() {
        var circle = CircleRenderableComponent(radius: 50.0)

        circle = circle.fill(color: .green)
        XCTAssertEqual(circle.fillInfo?.color, AbstractColor.green)

        circle = circle.stroke(lineWidth: 5.0, color: .red)
        XCTAssertEqual(circle.strokeInfo?.lineWidth, 5.0)
        XCTAssertEqual(circle.strokeInfo?.color, AbstractColor.red)
    }

    func testLabel() {
        var circle = CircleRenderableComponent(radius: 50.0)

        circle = circle.label("New Label")
        XCTAssertEqual(circle.labelInfo?.text, "New Label")
        XCTAssertEqual(circle.labelInfo?.color, AbstractColor.black)

        circle = circle.label("Another Label", color: .red, size: 18)
        XCTAssertEqual(circle.labelInfo?.text, "Another Label")
        XCTAssertEqual(circle.labelInfo?.color, AbstractColor.red)
        XCTAssertEqual(circle.labelInfo?.size, 18)
    }

    func testModify() {
        let initialFillInfo = ShapeFillInfo(color: AbstractColor.blue)
        let initialStrokeInfo = ShapeStrokeInfo(lineWidth: 3.0, color: AbstractColor.red)
        let initialLabelInfo = ShapeLabelInfo(text: "Start", color: AbstractColor.white, size: 16)

        var circle = CircleRenderableComponent(
            radius: 40.0,
            fillInfo: initialFillInfo,
            strokeInfo: initialStrokeInfo,
            labelInfo: initialLabelInfo
        )

        let updatedFillInfo = ShapeFillInfo(color: AbstractColor.green)
        let updatedStrokeInfo = ShapeStrokeInfo(lineWidth: 4.0, color: AbstractColor.red)
        let updatedLabelInfo = ShapeLabelInfo(text: "End", color: AbstractColor.black, size: 18)

        circle = circle.modify(
            fillInfo: updatedFillInfo,
            strokeInfo: updatedStrokeInfo,
            labelInfo: updatedLabelInfo
        )

        XCTAssertEqual(circle.fillInfo?.color, updatedFillInfo.color)
        XCTAssertEqual(circle.strokeInfo?.lineWidth, updatedStrokeInfo.lineWidth)
        XCTAssertEqual(circle.labelInfo?.text, updatedLabelInfo.text)
    }

    func testOnTapDelegate() {
        let circle = CircleRenderableComponent(radius: 50.0)
        let tapDelegate: TapDelegate = {

        }

        let modifiedCircle = circle.modify(onTapDelegate: tapDelegate)

        XCTAssertNotNil(modifiedCircle.onTapDelegate)
    }
}
