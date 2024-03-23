protocol CanvasComponentUpdater {
    func update(_ circle: CircleRenderableComponent) -> CircleRenderableComponent
    func update(_ rect: RectRenderableComponent) -> RectRenderableComponent
    func update(_ polygon: PolygonRenderableComponent) -> PolygonRenderableComponent
    func update(_ image: BitmapImageRenderableComponent) -> BitmapImageRenderableComponent
    func update(_ button: ButtonRenderableComponent) -> ButtonRenderableComponent
    func update(_ joystick: JoystickRenderableComponent) -> JoystickRenderableComponent
}
