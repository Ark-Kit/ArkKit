import Foundation

protocol CanvasContext {
    typealias RenderableComponentType = ObjectIdentifier
    var canvasFrame: CGRect { get }
    var memo: [EntityID: [RenderableComponentType: (any RenderableComponent, any Renderable)]] { get }
    func getCanvas() -> Canvas
    func render(_ canvas: any Canvas, using renderer: any CanvasRenderer)
}

class ArkCanvasContext: CanvasContext {
    private(set) var canvasFrame: CGRect
    var memo: [EntityID: [RenderableComponentType: (any RenderableComponent, any Renderable)]] = [:]
    private let ecs: ArkECS
    init(ecs: ArkECS, canvasFrame: CGRect) {
        self.ecs = ecs
        self.canvasFrame = canvasFrame
    }

    func render(_ canvas: any Canvas, using renderer: any CanvasRenderer) {
        // unmounting outdated components
        for (entityId, component) in canvas.componentsToUnmount {
            for (componentType, renderable) in component {
                renderable?.unmount()
                memo[entityId]?.removeValue(forKey: componentType)
            }
        }

        // rerendering - unmounting old, rendering new
        for (entityId, component) in canvas.componentsToMount {
            for (componentType, renderableComponent) in component {
                if let (previousCanvasComp, previousRenderable) = memo[entityId]?[componentType] {
                    if !renderableComponent.hasUpdated(previous: previousCanvasComp) {
                        continue
                    }
                    previousRenderable.unmount()
                }
                let renderable = renderableComponent.render(using: renderer)
                renderer.upsertToView(renderable, at: renderableComponent.renderLayer)
                if memo[entityId] != nil {
                    memo[entityId]?[componentType] = (renderableComponent, renderable)
                } else {
                    memo[entityId] = [componentType: (renderableComponent, renderable)]
                }
            }
        }
    }

    func getCanvas() -> any Canvas {
        var arkCanvas = ArkCanvas()
        for canvasCompType in ArkCanvasSystem.canvasComponentTypes {
            let entitiesWithCanvas = ecs.getEntities(with: [canvasCompType])
            let componentType = ObjectIdentifier(canvasCompType)
            // check if entity has outdaeted canvas components
            let validEntityIds = Set(entitiesWithCanvas.map { entity in entity.id })
            for entityId in memo.keys where !validEntityIds.contains(entityId) {
                // entity is no longer valid
                if let renderableFromEntity = memo[entityId]?[componentType] {
                    arkCanvas.addComponentToUnmount(entityId: entityId,
                                                    componentType: componentType,
                                                    renderable: renderableFromEntity.1)
                }
            }

            // update canvas
            for entity in entitiesWithCanvas {
                guard let renderableComponent = ecs.getComponent(ofType: canvasCompType, for: entity) else {
                    continue
                }
                if let (previousRenderableComponent, _) = memo[entity.id]?[componentType] {
                    if !renderableComponent.hasUpdated(previous: previousRenderableComponent) {
                        continue
                    }
                }
                arkCanvas.addComponentToMount(entityId: entity.id,
                                              componentType: componentType,
                                              renderableComponent: renderableComponent)
            }
        }
        return arkCanvas
    }
}
