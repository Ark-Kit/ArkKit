import Foundation

protocol CanvasComponentUpdater {
    func update(_ circle: CircleCanvasComponent) -> CircleCanvasComponent
    func update(_ rect: RectCanvasComponent) -> RectCanvasComponent
    func update(_ polygon: PolygonCanvasComponent) -> PolygonCanvasComponent
    func update(_ image: BitmapImageCanvasComponent) -> BitmapImageCanvasComponent
    func update(_ button: ButtonCanvasComponent) -> ButtonCanvasComponent
    func update(_ joystick: JoystickCanvasComponent) -> JoystickCanvasComponent
}

struct CanvasComponentPositionUpdater: CanvasComponentUpdater {
    let position: CGPoint
    func update(_ circle: CircleCanvasComponent) -> CircleCanvasComponent {
        CircleCanvasComponent(radius: circle.radius,
                                            center: position,
                                            areValuesEqual: circle.areValuesEqual)
        .modify(fillInfo: circle.fillInfo, strokeInfo: circle.strokeInfo)
    }

    func update(_ rect: RectCanvasComponent) -> RectCanvasComponent {
        RectCanvasComponent(width: rect.width, height: rect.height,
                            center: position, areValuesEqual: rect.areValuesEqual)
        .modify(fillInfo: rect.fillInfo, strokeInfo: rect.strokeInfo)
    }

    func update(_ polygon: PolygonCanvasComponent) -> PolygonCanvasComponent {
        // TODO: update polygon position updater once polygon is supported
        // need to translate all points on polygon and the frame
        polygon
    }

    func update(_ image: BitmapImageCanvasComponent) -> BitmapImageCanvasComponent {
        BitmapImageCanvasComponent(imageResourcePath: image.imageResourcePath,
                                   center: position,
                                   width: image.width,
                                   height: image.height,
                                   areValuesEqual: image.areValuesEqual)
        .immutableCopy(isClipToBounds: image.isClipToBounds,
                       isScaleAspectFit: image.isScaleAspectFit,
                       isScaleToFill: image.isScaleToFill,
                       isScaleAspectFill: image.isScaleAspectFill)
    }

    func update(_ button: ButtonCanvasComponent) -> ButtonCanvasComponent {
        ButtonCanvasComponent(width: button.width, height: button.height, center: position,
                              areValuesEqual: button.areValuesEqual)
        .modify(onTapDelegate: button.onTapDelegate)
    }

    func update(_ joystick: JoystickCanvasComponent) -> JoystickCanvasComponent {
        JoystickCanvasComponent(center: position, radius: joystick.radius,
                                areValuesEqual: joystick.areValuesEqual)
        .modify(onPanStartDelegate: joystick.onPanStartDelegate,
                onPanChangeDelegate: joystick.onPanChangeDelegate,
                onPanEndDelegate: joystick.onPanEndDelegate)
    }

}
