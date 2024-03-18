import Foundation

class ArkCanvasSystem: System {
    var active: Bool
    static let canvasComponentTypes: [CanvasComponent.Type] = [
        ButtonCanvasComponent.self,
        JoystickCanvasComponent.self,
        CircleCanvasComponent.self,
        RectCanvasComponent.self,
        PolygonCanvasComponent.self,
        BitmapImageCanvasComponent.self
    ]
    init(active: Bool = true) {
        self.active = active
    }
    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        let entitiesWithCanvas = arkECS.getEntities(with: ArkCanvasSystem.canvasComponentTypes)
        // TODO: this system should pull from relevant other component states to update
        // should mainly be from physics for now
    }
}
