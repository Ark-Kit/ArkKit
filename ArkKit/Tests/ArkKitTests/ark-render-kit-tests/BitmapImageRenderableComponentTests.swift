import XCTest
import CoreGraphics

@testable import ArkKit

class BitmapImageRenderableComponentTests: XCTestCase {

    func testInitialization() {
        let component = BitmapImageRenderableComponent(
            imageResourcePath: "image",
            width: 100.0,
            height: 100.0
        )

        XCTAssertEqual(component.imageResourcePath, "image")
        XCTAssertEqual(component.width, 100.0)
        XCTAssertEqual(component.height, 100.0)
        XCTAssertEqual(component.center, CGPoint.zero)
        XCTAssertEqual(component.rotation, 0.0)
        XCTAssertEqual(component.zPosition, 0.0)
        XCTAssertEqual(component.opacity, 1.0)
    }

    func testAttributeModifications() {
        var component = BitmapImageRenderableComponent(
            imageResourcePath: "image",
            width: 100.0,
            height: 100.0
        )

        component = component.center(x: 50.0, y: 50.0)
        XCTAssertEqual(component.center, CGPoint(x: 50.0, y: 50.0))

        component = component.rotation(45.0)
        XCTAssertEqual(component.rotation, 45.0)

        component = component.opacity(0.5)
        XCTAssertEqual(component.opacity, 0.5)

        component = component.layer(.canvas)
        XCTAssertEqual(component.renderLayer, .canvas)
    }

    func testChaining() {
        var component = BitmapImageRenderableComponent(
            imageResourcePath: "image",
            width: 100.0,
            height: 100.0
        )

        component = component.clipToBounds()
        XCTAssertTrue(component.isClipToBounds)

        component = component.scaleAspectFit()
        XCTAssertTrue(component.isScaleAspectFit)

        component = component.scaleToFill()
        XCTAssertTrue(component.isScaleToFill)

        component = component.scaleAspectFill()
        XCTAssertTrue(component.isScaleAspectFill)
    }

    func testAreValuesEqual() {
        let component1 = BitmapImageRenderableComponent(
            imageResourcePath: "image",
            width: 100.0,
            height: 100.0
        )

        var component2 = component1

        XCTAssertTrue(component1.hasUpdated(previous: component2))

        }

    func testShouldRerender() {
        let component = BitmapImageRenderableComponent(
            imageResourcePath: "image",
            width: 100.0,
            height: 100.0
        ).shouldRerender { old, new in
            old.rotation != new.rotation
        }

        var updatedComponent = component.rotation(90.0)

        XCTAssertTrue(component.hasUpdated(previous: updatedComponent))

        updatedComponent = component.rotation(45.0)

        XCTAssertTrue(component.hasUpdated(previous: updatedComponent))
    }
}
