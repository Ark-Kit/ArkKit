struct ArkCanvas: Canvas {
    var componentsToUnmount: [EntityID: [RenderableComponentType: (any Renderable)?]] = [:]
    var componentsToMount: [EntityID: [RenderableComponentType: any RenderableComponent]] = [:]

    mutating func addComponentToUnmount(entityId: EntityID,
                                        componentType: RenderableComponentType,
                                        renderable: (any Renderable)?) {
        if componentsToUnmount[entityId] != nil {
            componentsToUnmount[entityId]?[componentType] = renderable
        } else {
            componentsToUnmount[entityId] = [componentType: renderable]
        }
    }
    mutating func addComponentToMount(entityId: EntityID,
                                      componentType: RenderableComponentType,
                                      renderableComponent: any RenderableComponent) {
        if componentsToMount[entityId] != nil {
            componentsToMount[entityId]?[componentType] = renderableComponent
        } else {
            componentsToMount[entityId] = [componentType: renderableComponent]
        }
    }
//    var canvasComponentsToRender: [(Entity, any RenderableComponent, any RenderableComponent.Type)] = []
//    var canvasRenderablesToUnmount: [(Entity, any RenderableComponent.Type)] = []
//
//    func render(using renderer: any CanvasRenderer, to context: CanvasContext) {
//        for (entity, canvasComponent, compType) in canvasComponentsToRender {
//            if let (_, prevRenderable) = context.memo[entity]?[ObjectIdentifier(compType)] {
//                prevRenderable.unmount()
//            }
//            let renderable = canvasComponent.render(using: renderer)
//            context.saveToMemo(entity: entity, canvasComponentType: compType,
//                               canvasComponent: canvasComponent, renderable: renderable)
//        }
//    }
//
//    func unmount(from context: CanvasContext) {
//        for (entity, canvasComponentType) in canvasRenderablesToUnmount {
//            let renderable = context.removeFromMemo(entity: entity, canvasComponentType: canvasComponentType)
//            renderable?.unmount()
//        }
//    }
//    mutating func addToRender(entity: Entity,
//                              canvasComponent: any RenderableComponent,
//                              compType: any RenderableComponent.Type) {
//        canvasComponentsToRender.append((entity, canvasComponent, compType))
//    }
//    mutating func addToUnmount(entity: Entity, compType: any RenderableComponent.Type, context: CanvasContext) {
//        canvasRenderablesToUnmount.append((entity, compType))
//    }
}
