import Foundation

protocol CameraContext {
    var cameraEntities: [Entity] { get }
    var displayContext: DisplayContext { get }

    func transform(_ canvas: any Canvas) -> any Canvas
}

class ArkCameraContext: CameraContext {
    private let ecs: ArkECSContext
    let displayContext: DisplayContext

    var cameraEntities: [Entity] {
        ecs.getEntities(with: [CameraContainerComponent.self])
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

        var transformedCanvas = ArkMegaCanvas(screenElements: filterForScreenComponents(canvas))

        for cameraEntity in cameras {
            guard let cameraContainerComp = ecs.getComponent(
                ofType: CameraContainerComponent.self, for: cameraEntity
            ) else {
                continue
            }

            let containerRenderable = collectCanvasToContainerAndTranslate(canvas, placedCamera: cameraContainerComp)

            transformedCanvas.addEntityRenderableToCanvas(
                entityId: cameraEntity.id,
                componentType: ObjectIdentifier(ContainerRenderableComponent.self),
                renderableComponent: containerRenderable
            )
        }
        return transformedCanvas
    }

    private func collectCanvasToContainerAndTranslate(
        _ cameraCanva: any Canvas,
        placedCamera: CameraContainerComponent
    ) -> ContainerRenderableComponent {
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

        let canvasCameraPosition = CGPoint(
            x: placedCamera.screenPosition.x / displayContext.screenSize.width * displayContext.canvasSize.width,
            y: placedCamera.screenPosition.y / displayContext.screenSize.height * displayContext.canvasSize.height
        )

        let translation = CGAffineTransform(
            translationX: canvasCameraPosition.x - placedCamera.camera.canvasPosition.x,
            y: canvasCameraPosition.y - placedCamera.camera.canvasPosition.y
        )
        return ContainerRenderableComponent(
            center: placedCamera.camera.canvasPosition.applying(translation)/*CGPoint(x: 410, y: 590)*/,
            size: displayContext.canvasSize, // needs the "world size" as the component size
            renderLayer: .canvas,
            zPosition: 0,
            renderableComponents: renderableComponents.map { comp in
                var copy = comp
                copy.center = copy.center.applying(translation)
                return copy
            }
        )
        .setIsUserInteractionEnabled(false)
        .mask(size: placedCamera.size,
              origin: CGPoint(
                x: placedCamera.screenPosition.x - placedCamera.size.width / 2,
                y: placedCamera.screenPosition.y - placedCamera.size.height / 2
              ))
        .letterbox(into: displayContext.screenSize)
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
