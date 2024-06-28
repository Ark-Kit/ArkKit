import XCTest
@testable import ArkKit

class ArkCameraContextTests: XCTestCase {
    func testEmptyCanvasTransformation() {
        // Setup
        let mockECS = MockECSContext()
        let mockDisplayContext = MockDisplayContext()
        let context = ArkCameraContext(ecs: mockECS, displayContext: mockDisplayContext)
        let canvas = MockCanvas()

        // Action
        let transformedCanvas = context.transform(canvas)

        // Assertion
        XCTAssertEqual(canvas.canvasElements.count, 0)
        XCTAssertEqual(transformedCanvas.canvasElements.count, 0)
    }

    func testCanvasWithCameraEntities() {
        let ecs = ArkECS()
        let mockPosition = CGPoint(x: 0, y: 0)
        ecs.createEntity(with: [PlacedCameraComponent(
            camera: Camera(canvasPosition: mockPosition),
            screenPosition: mockPosition, size: CGSize(width: 0, height: 0)
        )])
        let canvasContext = ArkCanvasContext(ecs: ecs, arkView: MockView())
        let context = ArkCameraContext(ecs: ecs, displayContext: MockDisplayContext())
        let canvasToTransform = canvasContext.getFlatCanvas()
        let transformedCanvas = context.transform(canvasToTransform)
        // get entity from canvas
        XCTAssertEqual(0, canvasToTransform.canvasElements.count) // no renderable component
        XCTAssertEqual(1, transformedCanvas.canvasElements.count) // should have 1 CameraContainerRenderableComponent
    }

    func testCanvasWithCameraEntitiesThatHasRenderable() {
        let ecs = ArkECS()
        let mockPosition = CGPoint(x: 0, y: 0)
        ecs.createEntity(with: [
            PlacedCameraComponent(
                camera: Camera(canvasPosition: mockPosition),
                screenPosition: mockPosition, size: CGSize(width: 0, height: 0)
            ),
            ButtonRenderableComponent(width: 0.0, height: 0.0)
        ])
        let canvasContext = ArkCanvasContext(ecs: ecs, arkView: MockView())
        let context = ArkCameraContext(ecs: ecs, displayContext: MockDisplayContext())
        let canvasToTransform = canvasContext.getFlatCanvas()
        let transformedCanvas = context.transform(canvasToTransform)
        // get entity from canvas
        XCTAssertEqual(1, canvasToTransform.canvasElements.count) // no renderable component
        XCTAssertEqual(1, transformedCanvas.canvasElements.count) // should have 1 CameraContainerRenderableComponent
    }

    func testCameraSystem_shouldUpdatePosition() {
        let ecs = ArkECS()
        let originalPosition = CGPoint(x: 0, y: 0)
        let entity = ecs.createEntity(with: [
            PlacedCameraComponent(
                camera: Camera(canvasPosition: originalPosition),
                screenPosition: originalPosition, size: CGSize(width: 0, height: 0)
            ),
            ButtonRenderableComponent(width: 0.0, height: 0.0),
            PositionComponent(position: originalPosition)
        ])
        // update position of entity
        let updatedPosition = CGPoint(x: 1, y: 0)
        ecs.upsertComponent(PositionComponent(position: updatedPosition), to: entity)
        let cameraSystem = ArkCameraSystem()
        cameraSystem.update(deltaTime: 1 / 60, arkECS: ecs)
        guard let camComponent = ecs.getComponent(ofType: PlacedCameraComponent.self, for: entity) else {
            XCTAssertFalse(true)
            return
        }
        XCTAssertEqual(camComponent.camera.canvasPosition, updatedPosition)
    }
}
