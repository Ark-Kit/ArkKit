import Foundation

protocol CameraContext {
    func transform(_ canvas: any Canvas) -> any Canvas
}

class ArkCameraContext: CameraContext {
    private let ecs: ArkECSContext

    init(ecs: ArkECSContext) {
        self.ecs = ecs
    }

    func transform(_ canvas: any Canvas) -> any Canvas {
        let cameraEntities = ecs.getEntities(with: [CameraContainerComponent.self])

        if cameraEntities.isEmpty {
            return canvas
        }

        // transform the canvas into a camera canvas by translating positions
        let cameraTranslatedCanvas: [any Canvas] = cameraEntities.map { cameraEntity in
            guard let cameraContainerComp = ecs.getComponent(
                ofType: CameraContainerComponent.self, for: cameraEntity
            ) else {
                return ArkCanvas()
            }
            return translateCanvasToCamera(cameraContainerComp, original: canvas)
        }
        return cameraTranslatedCanvas.first ?? ArkCanvas()
    }

    private func translateCanvasToCamera(_ cameraContainerComp: CameraContainerComponent,
                                         original canvas: Canvas) -> Canvas {
        var transformedCanvas = ArkCanvas()
        let fixedViewPosition = cameraContainerComp.screenPosition
        let canvasPosition = cameraContainerComp.camera.canvasPosition

        canvas.canvasEntityToRenderableMapping.forEach { entityId, mapping in
            mapping.forEach { compType, comp in
                if comp.renderLayer == .screen {
                    transformedCanvas.addEntityRenderableToCanvas(
                        entityId: entityId, componentType: compType, renderableComponent: comp
                    )
                    return
                }

                var copy = comp
                copy.center = translate(point: comp.center, by: CGPoint(
                    x: fixedViewPosition.x - canvasPosition.x,
                    y: fixedViewPosition.y - canvasPosition.y
                ))
                transformedCanvas.addEntityRenderableToCanvas(
                    entityId: entityId, componentType: compType, renderableComponent: copy
                )
            }
        }
        return transformedCanvas
    }

    private func translate(point: CGPoint, by translated: CGPoint) -> CGPoint {
        CGPoint(x: point.x + translated.x,
                y: point.y + translated.y)
    }
}
