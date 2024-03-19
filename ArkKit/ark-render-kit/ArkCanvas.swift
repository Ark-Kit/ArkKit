struct ArkCanvas: Canvas {
    var canvasComponents: [CanvasComponent] = []

    func render(using renderer: any CanvasRenderer) {
        for canvasComponent in canvasComponents {
            canvasComponent.render(using: renderer)
        }
    }

    mutating func add(_ canvasComponent: CanvasComponent) {
        canvasComponents.append(canvasComponent)
    }
}
