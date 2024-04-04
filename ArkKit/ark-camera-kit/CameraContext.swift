import Foundation

protocol CameraContext {
    var cameraEntities: [Entity] { get }
    func transform(_ canvas: any Canvas) -> any Canvas
}

class ArkCameraContext: CameraContext {
    private let ecs: ArkECSContext

    var cameraEntities: [Entity] {
        ecs.getEntities(with: [CameraContainerComponent.self])
    }

    init(ecs: ArkECSContext) {
        self.ecs = ecs
    }

    func transform(_ canvas: any Canvas) -> any Canvas {
        let cameras = cameraEntities

        if cameras.isEmpty {
            return canvas
        }

        var transformedCanvas = filterForScreenComponents(canvas)

        for cameraEntity in cameras {
            guard let cameraContainerComp = ecs.getComponent(
                ofType: CameraContainerComponent.self, for: cameraEntity
            ) else {
                continue
            }

            let cameraCanvas = translateCanvasToCamera(cameraContainerComp, original: canvas)
            let containerRenderable = collectCameraCanvasToContainer(cameraCanvas, placedCamera: cameraContainerComp)
            transformedCanvas.addEntityRenderableToCanvas(
                entityId: cameraEntity.id,
                componentType: ObjectIdentifier(ContainerRenderableComponent.self),
                renderableComponent: containerRenderable
            )
        }
        return transformedCanvas
    }

    private func collectCameraCanvasToContainer(
        _ cameraCanva: any Canvas,
        placedCamera: CameraContainerComponent
    ) -> ContainerRenderableComponent {
        let renderableComponents = cameraCanva.canvasEntityToRenderableMapping.flatMap { _, mapping in mapping.values }
        return ContainerRenderableComponent(
            center: placedCamera.screenPosition,
            size: placedCamera.camera.size,
            zPosition: 0,
            renderableComponents: renderableComponents
        )
    }
    private func translateCanvasToCamera(_ cameraContainerComp: CameraContainerComponent,
                                         original canvas: Canvas) -> Canvas {
        var transformedCanvas = ArkCanvas()
        let fixedViewPosition = cameraContainerComp.screenPosition
        let canvasPosition = cameraContainerComp.camera.canvasPosition

        canvas.canvasEntityToRenderableMapping.forEach { entityId, mapping in
            mapping.forEach { compType, comp in
                if comp.renderLayer == .screen {
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

    private func filterForScreenComponents(_ canvas: any Canvas) -> ArkCanvas {
        var transformedCanvas = ArkCanvas()
        canvas.canvasEntityToRenderableMapping.forEach { entityId, mapping in
            let screenRenderables = mapping.filter { _, comp in
                comp.renderLayer == .screen
            }
            for (compType, comp) in screenRenderables {
                transformedCanvas.addEntityRenderableToCanvas(entityId: entityId,
                                                              componentType: compType,
                                                              renderableComponent: comp)
            }
        }
        return transformedCanvas
    }
}
