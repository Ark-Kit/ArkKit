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
                let updatedCanvasComponent = upsertToECS(position: positionComponent.position,
                                                         canvasComponent: canvasComponent,
                                                         arkECS: arkECS, entity: entity)
                guard let rotationComponent = arkECS.getComponent(ofType: RotationComponent.self, for: entity),
                      let rotationAngle = rotationComponent.angleInRadians else {
                    continue
                }
                upsertToECS(rotationAngleInRadians: rotationAngle, canvasComponent: updatedCanvasComponent,
                            arkECS: arkECS, entity: entity)

            }
        }
    }

    @discardableResult private func upsertToECS(position: CGPoint,
                                                canvasComponent: any CanvasComponent,
                                                arkECS: ArkECS,
                                                entity: Entity) -> any CanvasComponent {
        let updatedCanvasComponent = canvasComponent.withPosition(position)
        arkECS.upsertComponent(updatedCanvasComponent, to: entity)
        return updatedCanvasComponent
    }

    @discardableResult private func upsertToECS(rotationAngleInRadians: Double,
                                                canvasComponent: any CanvasComponent,
                                                arkECS: ArkECS,
                                                entity: Entity) -> any CanvasComponent {
        let updatedCanvasComponent = canvasComponent.withRotation(rotationAngleInRadians)
        arkECS.upsertComponent(updatedCanvasComponent, to: entity)
        return updatedCanvasComponent
    }
}
