struct ArkCanvas: Canvas {
//    private(set) var componentsToUnmount: [EntityID: [RenderableComponentType: (any Renderable)?]] = [:]
    private(set) var canvasEntityToRenderableMapping: [EntityID: [RenderableComponentType: any RenderableComponent]] = [:]

//    mutating func addComponentToUnmount(entityId: EntityID,
//                                        componentType: RenderableComponentType,
//                                        renderable: (any Renderable)?) {
//        if componentsToUnmount[entityId] != nil {
//            componentsToUnmount[entityId]?[componentType] = renderable
//        } else {
//            componentsToUnmount[entityId] = [componentType: renderable]
//        }
//    }
    mutating func addEntityRenderableToCanvas(entityId: EntityID,
                                              componentType: RenderableComponentType,
                                              renderableComponent: any RenderableComponent) {
        if canvasEntityToRenderableMapping[entityId] != nil {
            canvasEntityToRenderableMapping[entityId]?[componentType] = renderableComponent
        } else {
            canvasEntityToRenderableMapping[entityId] = [componentType: renderableComponent]
        }
    }
}
