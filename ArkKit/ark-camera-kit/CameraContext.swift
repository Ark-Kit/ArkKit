import Foundation

protocol CameraContext {
    var cameraEntities: [Entity] { get }
    func transform(_ canvas: any Canvas) -> any Canvas
}

class ArkCameraContext: CameraContext {
    private let ecs: ArkECSContext
    private let screenSize: CGSize

    var cameraEntities: [Entity] {
        ecs.getEntities(with: [CameraContainerComponent.self])
    }

    init(ecs: ArkECSContext, screenSize: CGSize) {
        self.ecs = ecs
        self.screenSize = screenSize
    }

    /// Transforms the dumbest canvas into a Canvas with notion of Cameras.
    func transform(_ canvas: any Canvas) -> any Canvas {
        let cameras = cameraEntities

        if cameras.isEmpty {
            return canvas
        }

        var transformedCanvas = ArkMegaCanvas(screenElements: filterForScreenComponents(canvas))

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
        let renderableComponents = cameraCanva.canvasElements.flatMap { _, mapping in mapping.values }
        return ContainerRenderableComponent(
            center: CGPoint(x: 410, y: 590),
            size: CGSize(width: 820, height: 1_180),
            renderLayer: .canvas,
            zPosition: 0,
            renderableComponents: renderableComponents
        )
        .setIsUserInteractionEnabled(true)
        .mask(size: placedCamera.size,
              origin: CGPoint(
                x: placedCamera.screenPosition.x - placedCamera.size.width / 2,
                y: placedCamera.screenPosition.y - placedCamera.size.height / 2
              ))
        .letterbox(into: screenSize)
    }

    private func translateCanvasToCamera(_ cameraContainerComp: CameraContainerComponent,
                                         original canvas: Canvas) -> Canvas {
        var transformedCanvas = ArkFlatCanvas()

        canvas.canvasElements.forEach { entityId, mapping in
            mapping.forEach { compType, comp in
                if comp.renderLayer == .screen {
                    return
                }

                var copy = comp
//                copy.center = copy.center.applying(translation)
//                translate(point: comp.center, by: CGPoint(
//                    x: canvasPosition.x - fixedViewPosition.x,
//                    y: canvasPosition.y - fixedViewPosition.y
//                ))
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

    private func filterForScreenComponents(_ canvas: any Canvas) -> Canvas.CanvasElements {
        var result: Canvas.CanvasElements = [:]

        canvas.canvasElements.forEach { entityId, mapping in
            let screenRenderables = mapping.filter { _, comp in
                comp.renderLayer == .screen
            }
            for (compType, comp) in screenRenderables {
                if result[entityId] == nil {
                    result[entityId] = [:]
                }
                result[entityId]?[compType] = comp
            }
        }
        return result
    }
}
