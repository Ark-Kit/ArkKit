import UIKit

class ArkUIKitCanvasRenderer: CanvasRenderer {
    typealias ConcreteColor = UIColor

    var rootView: UIView
    init(rootView: UIView) {
        self.rootView = rootView
    }

    func render(_ circle: CircleCanvasComponent) {
        UIKitCircle(radius: circle.radius, center: circle.center)
            .applyModifiers(modifierInfo: circle, colorGetter: getColor)
            .render(into: rootView)
    }

    func render(_ rect: RectCanvasComponent) {
        UIKitRect(width: rect.width, height: rect.height, center: rect.center)
            .applyModifiers(modifierInfo: rect, colorGetter: getColor)
            .render(into: rootView)
    }

    func render(_ polygon: PolygonCanvasComponent) {
        UIKitPolygon(points: polygon.points, frame: polygon.frame)
            .applyModifiers(modifierInfo: polygon, colorGetter: getColor)
            .render(into: rootView)
    }

    func render(_ image: BitmapImageCanvasComponent) {
        UIKitImageBitmap(imageResourcePath: image.imageResourcePath,
                         center: image.center,
                         width: image.width,
                         height: image.height)
        .applyModifiers(modifierInfo: image)
        .render(into: rootView)
    }

    func render(_ button: ButtonCanvasComponent) {
        UIKitButton(width: button.width, height: button.height, center: button.center)
            .applyModifiers(modifierInfo: button)
            .render(into: rootView)
    }

    func render(_ joystick: JoystickCanvasComponent) {
        UIKitJoystick(center: joystick.center, radius: joystick.radius)
            .applyModifiers(modifierInfo: joystick)
            .render(into: rootView)
    }
    
    let defaultColor: UIColor = .black
    let colorMapping: [AbstractColor : UIColor] = [
        .default: .black,
        .blue: .blue,
        .red: .red,
        .green: .green,
        .black: .black
    ]
}
