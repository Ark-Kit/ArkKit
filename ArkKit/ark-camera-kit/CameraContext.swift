import Foundation

protocol CameraContext {
    var cameraEntities: [Entity] { get }
    var displayContext: DisplayContext { get }

    func transform(_ canvas: any Canvas) -> any Canvas
}

class ArkCameraContext: CameraContext {
    private let ecs: ArkECSContext
    private(set) var displayContext: DisplayContext

    var cameraEntities: [Entity] {
        ecs.getEntities(with: [PlacedCameraComponent.self])
    }

    init(ecs: ArkECSContext, displayContext: DisplayContext) {
        self.ecs = ecs
        self.displayContext = displayContext
    }

    /// Transforms the dumbest canvas into a Canvas with notion of Cameras.
    func transform(_ canvas: any Canvas) -> any Canvas {
        let cameras = cameraEntities

        if cameras.isEmpty {
            return canvas
        }

        var transformedCanvas = ArkCompositeCanvas(screenElements: filterForScreenComponents(canvas))

        for cameraEntity in cameras {
            guard let cameraContainerComp = ecs.getComponent(
                ofType: PlacedCameraComponent.self, for: cameraEntity
            ) else {
                continue
            }

            let containerRenderable = collectCanvasToContainerAndTranslate(canvas, placedCamera: cameraContainerComp)

            transformedCanvas.addEntityRenderableToCanvas(
                entityId: cameraEntity.id,
                componentType: ObjectIdentifier(CameraContainerRenderableComponent.self),
                renderableComponent: containerRenderable
            )
        }
        return transformedCanvas
    }

    private func collectCanvasToContainerAndTranslate(
        _ cameraCanva: any Canvas,
        placedCamera: PlacedCameraComponent
    ) -> CameraContainerRenderableComponent {
        var renderableComponents: [any RenderableComponent] = []
        cameraCanva.canvasElements.forEach { _, mapping in
            mapping.forEach { _, comp in
                if comp.renderLayer == .screen {
                    return
                }
                let copy = comp
                renderableComponents.append(copy)
            }
        }
        return CameraContainerRenderableComponent(
            center: CGPoint(x: displayContext.canvasSize.width / 2, y: displayContext.canvasSize.height / 2),
            size: displayContext.canvasSize,
            renderLayer: .canvas,
            zPosition: 0,
            renderableComponents: renderableComponents.map { comp in
                var copy = comp
                copy.center = copy.center
                return copy
            }
        )
        .track(placedCamera.camera.canvasPosition)
        .setIsUserInteractionEnabled(false)
        .letterbox(into: displayContext.screenSize)
        .zoom(by: placedCamera.camera.zoom)
        .mask(size: placedCamera.size,
              origin: CGPoint(
                x: placedCamera.screenPosition.x - placedCamera.size.width / 2,
                y: placedCamera.screenPosition.y - placedCamera.size.height / 2
              ))
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
