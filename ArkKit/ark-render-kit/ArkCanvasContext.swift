protocol ArkCanvasContext {
    func getCanvas() -> Canvas
}

extension ArkECS: ArkCanvasContext {
    func getCanvas() -> Canvas {
        var arkCanvas = ArkCanvas()
        let entitiesWithCanavs = self.getEntities(with: ArkCanvasSystem.canvasComponentTypes)
        for canvasCompType in ArkCanvasSystem.canvasComponentTypes {
            for entity in entitiesWithCanavs {
                guard let canvasComponent = self.getComponent(ofType: canvasCompType, for: entity) else {
                    continue
                }
                arkCanvas.add(canvasComponent)
            }
        }
        return arkCanvas
    }
}
