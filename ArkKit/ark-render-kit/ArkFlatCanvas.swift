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

struct ArkMegaCanvas: Canvas {
    var canvasElements: [EntityID: [RenderableComponentType: any RenderableComponent]] {
        // merge cameraElements and screenElements
        var mergedElements: [EntityID: [RenderableComponentType: any RenderableComponent]] = [:]

        for (entityID, componentDict) in cameraElements {
            if var existingDict = mergedElements[entityID] {
                existingDict.merge(componentDict, uniquingKeysWith: { _, new in new })
                mergedElements[entityID] = existingDict
            } else {
                mergedElements[entityID] = componentDict
            }
        }

        for (entityID, componentDict) in screenElements {
            if var existingDict = mergedElements[entityID] {
                existingDict.merge(componentDict, uniquingKeysWith: { _, new in new })
                mergedElements[entityID] = existingDict
            } else {
                mergedElements[entityID] = componentDict
            }
        }

        return mergedElements
    }

    private(set) var screenElements: Canvas.CanvasElements
    private(set) var cameraElements: Canvas.CanvasElements

    init(screenElements: Canvas.CanvasElements) {
        self.screenElements = screenElements
        self.cameraElements = [:]
    }

    mutating func addEntityRenderableToCanvas(entityId: EntityID,
                                              componentType: RenderableComponentType,
                                              renderableComponent: any RenderableComponent) {
        guard componentType == RenderableComponentType(CameraContainerRenderableComponent.self) else {
            return
        }
        if cameraElements[entityId] != nil {
            cameraElements[entityId]?[componentType] = renderableComponent
        } else {
            cameraElements[entityId] = [componentType: renderableComponent]
        }
    }
}
