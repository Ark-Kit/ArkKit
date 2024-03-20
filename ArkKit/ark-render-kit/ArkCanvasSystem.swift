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
                guard let canvasComponent = arkECS.getComponent(ofType: canvasCompType, for: entity),
                      let positionComponent = arkECS.getComponent(ofType: PositionComponent.self, for: entity) else {
                    continue
                }
                let positionUpdater = CanvasComponentPositionUpdater(position: positionComponent.position)
                let updatedCanvasComponent = canvasComponent.update(using: positionUpdater)
                arkECS.upsertComponent(updatedCanvasComponent, to: entity)
            }
        }
    }
}
