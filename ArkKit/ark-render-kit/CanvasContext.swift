protocol CanvasContext {
    var memo: [Entity: [ObjectIdentifier: (any CanvasComponent, any Renderable)]] { get }
    func getCanvas() -> Canvas
    func saveToMemo(entity: Entity, canvasComponentType: any CanvasComponent.Type,
                    canvasComponent: any CanvasComponent, renderable: any Renderable)
    func removeFromMemo(entity: Entity, canvasComponentType: any CanvasComponent.Type) -> (any Renderable)?
}

class ArkCanvasContext: CanvasContext {
    private(set) var memo: [Entity: [ObjectIdentifier: (any CanvasComponent, any Renderable)]]
    private let ecs: ArkECS
    init(ecs: ArkECS, memo: [Entity: [ObjectIdentifier: (any CanvasComponent, any Renderable)]] = [:]) {
        self.memo = memo
        self.ecs = ecs
    }
    func getCanvas() -> Canvas {
        var arkCanvas = ArkCanvas()
        for canvasCompType in ArkCanvasSystem.canvasComponentTypes {
            let entitiesWithCanvas = ecs.getEntities(with: [canvasCompType])
            arkCanvas = addOutdatedComponents(currentEntitiesWithCanvas: entitiesWithCanvas,
                                              canvasCompType: canvasCompType,
                                              canvas: arkCanvas)
            arkCanvas = addUpdatedComponents(currentEntitiesWithCanvas: entitiesWithCanvas,
                                             canvasCompType: canvasCompType,
                                             canvas: arkCanvas)
        }
        return arkCanvas
    }

    func saveToMemo(entity: Entity, canvasComponentType: any CanvasComponent.Type,
                    canvasComponent: any CanvasComponent, renderable: any Renderable) {
        if memo[entity] != nil {
            memo[entity]?[ObjectIdentifier(canvasComponentType)] = (canvasComponent, renderable)
            return
        }
        memo[entity] = [ObjectIdentifier(canvasComponentType): (canvasComponent, renderable)]

    }
    func removeFromMemo(entity: Entity, canvasComponentType: any CanvasComponent.Type) -> (any Renderable)? {
        guard let (_, renderable) = memo[entity]?[ObjectIdentifier(canvasComponentType)] else {
            return nil
        }
        return renderable
    }
    private func addOutdatedComponents(currentEntitiesWithCanvas: [Entity],
                                       canvasCompType: any CanvasComponent.Type,
                                       canvas: ArkCanvas) -> ArkCanvas {
        var arkCanvas = canvas
        let validEntities = Set(currentEntitiesWithCanvas)
        for entity in memo.keys where !validEntities.contains(entity) {
            arkCanvas.addToUnmount(entity: entity, compType: canvasCompType, context: self)
        }
        return arkCanvas
    }
    private func addUpdatedComponents(currentEntitiesWithCanvas: [Entity],
                                      canvasCompType: any CanvasComponent.Type,
                                      canvas: ArkCanvas) -> ArkCanvas {
        var arkCanvas = canvas
        for entity in currentEntitiesWithCanvas {
            guard let canvasComponent = ecs.getComponent(ofType: canvasCompType, for: entity) else {
                continue
            }
            if let (previousCanvasComp, _) = memo[entity]?[ObjectIdentifier(canvasCompType)] {
                if !canvasComponent.hasUpdated(previous: previousCanvasComp) {
                    continue
                }
            }
            arkCanvas.addToRender(entity: entity, canvasComponent: canvasComponent, compType: canvasCompType)
        }
        return arkCanvas
    }
}
