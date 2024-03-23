struct ArkCanvas: Canvas {
    private(set) var componentsToUnmount: [EntityID: [RenderableComponentType: (any Renderable)?]] = [:]
    private(set) var componentsToMount: [EntityID: [RenderableComponentType: any RenderableComponent]] = [:]

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
}
