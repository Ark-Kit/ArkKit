struct ArkCanvas: Canvas {
    private(set) var canvasEntityToRenderableMapping: [EntityID: [RenderableComponentType: any RenderableComponent]] = [:]

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
