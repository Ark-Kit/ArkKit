import Foundation

class ArkCanvasSystem: UpdateSystem {
    var active: Bool

    static let renderableComponentTypes: [any RenderableComponent.Type] = [
        ButtonRenderableComponent.self,
        JoystickRenderableComponent.self,
        CircleRenderableComponent.self,
        RectRenderableComponent.self,
        PolygonRenderableComponent.self,
        BitmapImageRenderableComponent.self,
        CameraContainerRenderableComponent.self
    ]

    init(active: Bool = true) {
        self.active = active
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        for canvasCompType in ArkCanvasSystem.renderableComponentTypes {
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
                                                canvasComponent: any RenderableComponent,
                                                arkECS: ArkECS,
                                                entity: Entity) -> any RenderableComponent {
        let updatedCanvasComponent = canvasComponent.center(position)
        arkECS.upsertComponent(updatedCanvasComponent, to: entity)
        return updatedCanvasComponent
    }

    @discardableResult private func upsertToECS(rotationAngleInRadians: Double,
                                                canvasComponent: any RenderableComponent,
                                                arkECS: ArkECS,
                                                entity: Entity) -> any RenderableComponent {
        let updatedCanvasComponent = canvasComponent.rotation(rotationAngleInRadians)
        arkECS.upsertComponent(updatedCanvasComponent, to: entity)
        return updatedCanvasComponent
    }
}
