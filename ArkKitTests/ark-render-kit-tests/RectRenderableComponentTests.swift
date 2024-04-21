import XCTest
import CoreGraphics

@testable import ArkKit

class RectRenderableComponentTests: XCTestCase {

    func testInitialization() {
        let fillColor = AbstractColor.red
        let strokeColor = AbstractColor.blue
        let rect = RectRenderableComponent(
            width: 100.0,
            height: 200.0,
            fillInfo: ShapeFillInfo(color: fillColor),
            strokeInfo: ShapeStrokeInfo(lineWidth: 2.0, color: strokeColor),
            labelInfo: ShapeLabelInfo(text: "Rectangle", color: .black, size: 14)
        )

        XCTAssertEqual(rect.width, 100.0)
        XCTAssertEqual(rect.height, 200.0)
        XCTAssertEqual(rect.fillInfo?.color, fillColor)
        XCTAssertEqual(rect.strokeInfo?.lineWidth, 2.0)
        XCTAssertEqual(rect.strokeInfo?.color, strokeColor)
        XCTAssertEqual(rect.labelInfo?.text, "Rectangle")
        XCTAssertEqual(rect.labelInfo?.color, AbstractColor.black)
        XCTAssertEqual(rect.labelInfo?.size, 14)
    }

    func testFillAndStroke() {
        var rect = RectRenderableComponent(width: 100.0, height: 200.0)

        rect = rect.fill(color: .green)
        XCTAssertEqual(rect.fillInfo?.color, AbstractColor.green)

        rect = rect.stroke(lineWidth: 5.0, color: .red)
        XCTAssertEqual(rect.strokeInfo?.lineWidth, 5.0)
        XCTAssertEqual(rect.strokeInfo?.color, AbstractColor.red)
    }

    func testLabel() {
        var rect = RectRenderableComponent(width: 100.0, height: 200.0)

        rect = rect.label("New Label")
        XCTAssertEqual(rect.labelInfo?.text, "New Label")
        XCTAssertEqual(rect.labelInfo?.color, AbstractColor.black)

        rect = rect.label("Another Label", color: .red, size: 18)
        XCTAssertEqual(rect.labelInfo?.text, "Another Label")
        XCTAssertEqual(rect.labelInfo?.color, AbstractColor.red)
        XCTAssertEqual(rect.labelInfo?.size, 18)
    }

    func testModify() {
        let initialFillInfo = ShapeFillInfo(color: AbstractColor.blue)
        let initialStrokeInfo = ShapeStrokeInfo(lineWidth: 3.0, color: AbstractColor.red)
        let initialLabelInfo = ShapeLabelInfo(text: "Start", color: AbstractColor.white, size: 16)

        var rect = RectRenderableComponent(
            width: 100.0,
            height: 200.0,
            fillInfo: initialFillInfo,
            strokeInfo: initialStrokeInfo,
            labelInfo: initialLabelInfo
        )

        let updatedFillInfo = ShapeFillInfo(color: AbstractColor.green)
        let updatedStrokeInfo = ShapeStrokeInfo(lineWidth: 4.0, color: AbstractColor.red)
        let updatedLabelInfo = ShapeLabelInfo(text: "End", color: AbstractColor.black, size: 18)

        rect = rect.modify(
            fillInfo: updatedFillInfo,
            strokeInfo: updatedStrokeInfo,
            labelInfo: updatedLabelInfo
        )

        XCTAssertEqual(rect.fillInfo?.color, updatedFillInfo.color)
        XCTAssertEqual(rect.strokeInfo?.lineWidth, updatedStrokeInfo.lineWidth)
        XCTAssertEqual(rect.labelInfo?.text, updatedLabelInfo.text)
    }

    func testOnTapDelegate() {
        let rect = RectRenderableComponent(width: 100.0, height: 200.0)
        let tapDelegate: TapDelegate = {
        }

        let modifiedRect = rect.modify(onTapDelegate: tapDelegate)

        XCTAssertNotNil(modifiedRect.onTapDelegate)
    }
}
