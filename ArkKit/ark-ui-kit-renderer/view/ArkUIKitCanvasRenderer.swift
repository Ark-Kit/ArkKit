import UIKit

class ArkUIKitCanvasRenderer: CanvasRenderer {
    typealias ConcreteColor = UIColor

    var rootView: UIView
    init(rootView: UIView) {
        self.rootView = rootView
    }

    // TODO: add letterbox functionality
    func render(_ circle: CircleCanvasComponent) -> any Renderable {
        let renderable = UIKitCircle(radius: circle.radius, center: circle.center)
            .applyModifiers(modifierInfo: circle, colorGetter: getColor)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ rect: RectCanvasComponent) -> any Renderable {
        let renderable = UIKitRect(width: rect.width, height: rect.height, center: rect.center)
            .applyModifiers(modifierInfo: rect, colorGetter: getColor)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ polygon: PolygonCanvasComponent) -> any Renderable {
        let renderable = UIKitPolygon(points: polygon.points, frame: polygon.frame)
            .applyModifiers(modifierInfo: polygon, colorGetter: getColor)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ image: BitmapImageCanvasComponent) -> any Renderable {
        let renderable = UIKitImageBitmap(imageResourcePath: image.imageResourcePath,
                                          center: image.center,
                                          width: image.width,
                                          height: image.height)
            .applyModifiers(modifierInfo: image)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ button: ButtonCanvasComponent) -> any Renderable {
        let renderable = UIKitButton(width: button.width, height: button.height, center: button.center)
            .applyModifiers(modifierInfo: button)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ joystick: JoystickCanvasComponent) -> any Renderable {
        let renderable = UIKitJoystick(center: joystick.center, radius: joystick.radius)
            .applyModifiers(modifierInfo: joystick)
        renderable.render(into: rootView)
        return renderable
    }

    let defaultColor: UIColor = .black
    let colorMapping: [AbstractColor: UIColor] = [
        .default: .black,
        .blue: .blue,
        .red: .red,
        .green: .green,
        .black: .black
    ]
}
