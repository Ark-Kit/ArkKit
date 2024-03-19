import Foundation

class ArkCanvasSystem: System {
    var active: Bool
    static let canvasComponentTypes: [any CanvasComponent.Type] = [
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
        for canvasCompType in ArkCanvasSystem.canvasComponentTypes {
            let entitiesWithCanvasComp = arkECS.getEntities(with: [canvasCompType])
            for entity in entitiesWithCanvasComp {
                let canvasComponent = arkECS.getComponent(ofType: canvasCompType, for: entity)
                // TODO: this system should pull from relevant other component states to update
                // should mainly be from physics
                // e.g. let positionComponent = arkECS.getComponent(ofType: PositionComponent.self, for entity)
                // NOTE: might need to employ a visitor because `CanvasComponent.Type`
                // is used as the main type
            }
        }
    }
}
