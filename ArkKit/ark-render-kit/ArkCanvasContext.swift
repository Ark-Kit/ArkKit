protocol ArkCanvasContext {
    func getCanvas() -> Canvas
}

extension ArkECS: ArkCanvasContext {
    func getCanvas() -> Canvas {
        var arkCanvas = ArkCanvas()
        for canvasCompType in ArkCanvasSystem.canvasComponentTypes {
            let entitiesWithCanvas = self.getEntities(with: [canvasCompType])
            for entity in entitiesWithCanvas {
                guard let canvasComponent = self.getComponent(ofType: canvasCompType, for: entity) else {
                    continue
                }
                arkCanvas.add(canvasComponent)
            }
        }
        return arkCanvas
    }
}
