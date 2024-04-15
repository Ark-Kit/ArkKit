struct ArkFlatCanvas: Canvas {
    private(set) var canvasElements: [EntityID: [RenderableComponentType: any RenderableComponent]] = [:]

    mutating func addEntityRenderableToCanvas(entityId: EntityID,
                                              componentType: RenderableComponentType,
                                              renderableComponent: any RenderableComponent) {
        if canvasElements[entityId] != nil {
            canvasElements[entityId]?[componentType] = renderableComponent
        } else {
            canvasElements[entityId] = [componentType: renderableComponent]
        }
    }
}
