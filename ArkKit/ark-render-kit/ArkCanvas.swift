struct ArkCanvas: Canvas {
    var canvasComponentsToRender: [(Entity, any CanvasComponent, any CanvasComponent.Type)] = []
    var canvasRenderablesToUnmount: [(Entity, any CanvasComponent.Type)] = []

    func render(using renderer: any CanvasRenderer, to context: CanvasContext) {
        for (entity, canvasComponent, compType) in canvasComponentsToRender {
            let renderable = canvasComponent.render(using: renderer)
            context.saveToMemo(entity: entity, canvasComponentType: compType,
                               canvasComponent: canvasComponent, renderable: renderable)
        }
    }

    func unmount(from context: CanvasContext) {
        for (entity, canvasComponentType) in canvasRenderablesToUnmount {
            let renderable = context.removeFromMemo(entity: entity, canvasComponentType: canvasComponentType)
            renderable?.unmount()
        }
    }
    mutating func addToRender(entity: Entity,
                              canvasComponent: any CanvasComponent,
                              compType: any CanvasComponent.Type) {
        canvasComponentsToRender.append((entity, canvasComponent, compType))
    }
    mutating func addToUnmount(entity: Entity, compType: any CanvasComponent.Type, context: CanvasContext) {
        canvasRenderablesToUnmount.append((entity, compType))
    }
}
