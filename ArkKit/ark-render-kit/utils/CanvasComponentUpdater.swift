protocol CanvasComponentUpdater {
    func update(_ circle: CircleCanvasComponent) -> CircleCanvasComponent
    func update(_ rect: RectCanvasComponent) -> RectCanvasComponent
    func update(_ polygon: PolygonCanvasComponent) -> PolygonCanvasComponent
    func update(_ image: BitmapImageCanvasComponent) -> BitmapImageCanvasComponent
    func update(_ button: ButtonCanvasComponent) -> ButtonCanvasComponent
    func update(_ joystick: JoystickCanvasComponent) -> JoystickCanvasComponent
}
