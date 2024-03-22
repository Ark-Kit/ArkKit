import Foundation

struct CanvasComponentRotationUpdater: CanvasComponentUpdater {
    let rotation: Double
    func update(_ circle: CircleCanvasComponent) -> CircleCanvasComponent {
        CircleCanvasComponent(radius: circle.radius,
                              center: circle.center,
                              rotation: rotation,
                              areValuesEqual: circle.areValuesEqual)
        .modify(fillInfo: circle.fillInfo, strokeInfo: circle.strokeInfo)
    }

    func update(_ rect: RectCanvasComponent) -> RectCanvasComponent {
        RectCanvasComponent(width: rect.width, height: rect.height,
                            center: rect.center,
                            rotation: rotation,
                            areValuesEqual: rect.areValuesEqual)
        .modify(fillInfo: rect.fillInfo, strokeInfo: rect.strokeInfo)
    }

    func update(_ polygon: PolygonCanvasComponent) -> PolygonCanvasComponent {
        // TODO: update polygon position updater once polygon is supported
        // need to translate all points on polygon and the frame
        polygon
    }

    func update(_ image: BitmapImageCanvasComponent) -> BitmapImageCanvasComponent {
        BitmapImageCanvasComponent(imageResourcePath: image.imageResourcePath,
                                   center: image.center,
                                   width: image.width,
                                   height: image.height,
                                   rotation: rotation,
                                   areValuesEqual: image.areValuesEqual)
        .immutableCopy(isClipToBounds: image.isClipToBounds,
                       isScaleAspectFit: image.isScaleAspectFit,
                       isScaleToFill: image.isScaleToFill,
                       isScaleAspectFill: image.isScaleAspectFill)
    }

    func update(_ button: ButtonCanvasComponent) -> ButtonCanvasComponent {
        ButtonCanvasComponent(width: button.width, height: button.height, center: button.center,
                              rotation: rotation,
                              areValuesEqual: button.areValuesEqual)
        .modify(onTapDelegate: button.onTapDelegate)
    }

    func update(_ joystick: JoystickCanvasComponent) -> JoystickCanvasComponent {
        JoystickCanvasComponent(center: joystick.center, radius: joystick.radius,
                                rotation: rotation,
                                areValuesEqual: joystick.areValuesEqual)
        .modify(onPanStartDelegate: joystick.onPanStartDelegate,
                onPanChangeDelegate: joystick.onPanChangeDelegate,
                onPanEndDelegate: joystick.onPanEndDelegate)
    }
}
