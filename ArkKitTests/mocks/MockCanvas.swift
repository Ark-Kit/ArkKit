@testable import ArkKit

class MockCanvas: Canvas {
    var canvasElements: CanvasElements = [:]

    func addEntityRenderableToCanvas(entityId: ArkKit.EntityID,
                                     componentType: RenderableComponentType,
                                     renderableComponent: any ArkKit.RenderableComponent) {
        // mock
    }
}
