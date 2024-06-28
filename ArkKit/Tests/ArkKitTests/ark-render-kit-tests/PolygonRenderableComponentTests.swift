import XCTest
import CoreGraphics

@testable import ArkKit

class PolygonRenderableComponentTests: XCTestCase {

    func testInitialization() {
        let points = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 100.0, y: 0.0),
            CGPoint(x: 100.0, y: 100.0),
            CGPoint(x: 0.0, y: 100.0)
        ]
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

        let polygon = PolygonRenderableComponent(
            points: points,
            frame: frame,
            fillInfo: ShapeFillInfo(color: AbstractColor.blue),
            strokeInfo: ShapeStrokeInfo(lineWidth: 2.0, color: AbstractColor.green),
            labelInfo: ShapeLabelInfo(text: "Polygon", color: AbstractColor.black, size: 14)
        )

        XCTAssertEqual(polygon.points, points)
        XCTAssertEqual(polygon.frame, frame)
        XCTAssertEqual(polygon.fillInfo?.color, AbstractColor.blue)
        XCTAssertEqual(polygon.strokeInfo?.lineWidth, 2.0)
        XCTAssertEqual(polygon.strokeInfo?.color, AbstractColor.green)
        XCTAssertEqual(polygon.labelInfo?.text, "Polygon")
        XCTAssertEqual(polygon.labelInfo?.color, AbstractColor.black)
        XCTAssertEqual(polygon.labelInfo?.size, 14)
    }

    func testFillAndStroke() {
        let points = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 100.0, y: 0.0),
            CGPoint(x: 100.0, y: 100.0),
            CGPoint(x: 0.0, y: 100.0)
        ]
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

        var polygon = PolygonRenderableComponent(points: points, frame: frame)

        polygon = polygon.fill(color: AbstractColor.red)
        XCTAssertEqual(polygon.fillInfo?.color, AbstractColor.red)

        polygon = polygon.stroke(lineWidth: 3.0, color: AbstractColor.blue)
        XCTAssertEqual(polygon.strokeInfo?.lineWidth, 3.0)
        XCTAssertEqual(polygon.strokeInfo?.color, AbstractColor.blue)
    }

    func testLabel() {
        let points = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 100.0, y: 0.0),
            CGPoint(x: 100.0, y: 100.0),
            CGPoint(x: 0.0, y: 100.0)
        ]
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

        var polygon = PolygonRenderableComponent(points: points, frame: frame)

        polygon = polygon.label("New Label")
        XCTAssertEqual(polygon.labelInfo?.text, "New Label")
        XCTAssertEqual(polygon.labelInfo?.color, AbstractColor.black)

        polygon = polygon.label("Another Label", color: AbstractColor.red, size: 18)
        XCTAssertEqual(polygon.labelInfo?.text, "Another Label")
        XCTAssertEqual(polygon.labelInfo?.color, AbstractColor.red)
        XCTAssertEqual(polygon.labelInfo?.size, 18)
    }

    func testModify() {
        let points = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 100.0, y: 0.0),
            CGPoint(x: 100.0, y: 100.0),
            CGPoint(x: 0.0, y: 100.0)
        ]
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

        var polygon = PolygonRenderableComponent(
            points: points,
            frame: frame,
            fillInfo: ShapeFillInfo(color: AbstractColor.red),
            strokeInfo: ShapeStrokeInfo(lineWidth: 2.0, color: AbstractColor.blue),
            labelInfo: ShapeLabelInfo(text: "Polygon", color: AbstractColor.black, size: 14)
        )

        let updatedFillInfo = ShapeFillInfo(color: AbstractColor.green)
        let updatedStrokeInfo = ShapeStrokeInfo(lineWidth: 3.0, color: AbstractColor.red)
        let updatedLabelInfo = ShapeLabelInfo(text: "Updated", color: AbstractColor.white, size: 16)

        polygon = polygon.modify(
            fillInfo: updatedFillInfo,
            strokeInfo: updatedStrokeInfo,
            labelInfo: updatedLabelInfo
        )

        XCTAssertEqual(polygon.fillInfo?.color, updatedFillInfo.color)
        XCTAssertEqual(polygon.strokeInfo?.lineWidth, updatedStrokeInfo.lineWidth)
        XCTAssertEqual(polygon.labelInfo?.text, updatedLabelInfo.text)
    }

    func testOnTapDelegate() {
        let points = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 100.0, y: 0.0),
            CGPoint(x: 100.0, y: 100.0),
            CGPoint(x: 0.0, y: 100.0)
        ]
        let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

        let polygon = PolygonRenderableComponent(points: points, frame: frame)
        let tapDelegate: TapDelegate = {
        }

        var modifiedPolygon = polygon.modify(onTapDelegate: tapDelegate)

        XCTAssertNotNil(modifiedPolygon.onTapDelegate)
    }
}
