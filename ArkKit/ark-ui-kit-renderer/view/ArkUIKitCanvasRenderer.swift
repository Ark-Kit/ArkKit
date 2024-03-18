import UIKit

class ArkUIKitCanvasRenderer: CanvasRenderer {
    var rootView: UIView
    init(rootView: UIView) {
        self.rootView = rootView
    }

    func render(_ circle: CircleCanvasComponent) {
        UIKitCircle(radius: circle.radius, center: circle.center)
            .render(into: rootView)
    }

    func render(_ rect: RectCanvasComponent) {
        UIKitRect(width: rect.width, height: rect.height, center: rect.center)
            .render(into: rootView)
    }

    func render(_ polygon: PolygonCanvasComponent) {
        UIKitPolygon(points: polygon.points, frame: polygon.frame)
            .render(into: rootView)
    }

    func render(_ image: BitmapImageCanvasComponent) {
        UIKitImageBitmap(imageResourcePath: image.imageResourcePath,
                         center: image.center,
                         width: image.width,
                         height: image.height)
        .render(into: rootView)
    }

    func render(_ button: ButtonCanvasComponent) {
        UIKitButton(width: button.width, height: button.height, center: button.center)
            .render(into: rootView)
    }

    func render(_ joystick: JoystickCanvasComponent) {
        UIKitJoystick(center: joystick.center, radius: joystick.radius)
            .render(into: rootView)
    }
}
