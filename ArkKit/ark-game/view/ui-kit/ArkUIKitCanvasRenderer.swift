import UIKit

class ArkUIKitCanvasRenderer: CanvasRenderer {
    typealias ConcreteColor = UIColor

    var rootView: UIView
    var canvasView: UIView

    init(rootView: UIView, canvasView: UIView, canvasFrame: CGRect) {
        self.rootView = rootView
        self.canvasView = canvasView
        // Scale canvasView to fit the rootView
        let scaleFactor = letterboxScaleFactor(rootFrame: rootView.frame, canvasFrame: canvasFrame)

        canvasView.bounds = canvasFrame
        canvasView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        canvasView.center = rootView.center
    }

    func render(_ circle: CircleCanvasComponent) -> any Renderable {
        let renderable = UIKitCircle(radius: circle.radius, center: circle.center)
            .rotate(by: circle.rotation)
            .zPosition(circle.zPosition)
            .applyModifiers(modifierInfo: circle, colorGetter: getColor)
        renderable.render(into: canvasView)
        return renderable
    }

    func render(_ rect: RectCanvasComponent) -> any Renderable {
        let renderable = UIKitRect(width: rect.width, height: rect.height,
                                   center: rect.center)
            .rotate(by: rect.rotation)
            .zPosition(rect.zPosition)
            .applyModifiers(modifierInfo: rect, colorGetter: getColor)
        renderable.render(into: canvasView)
        return renderable
    }

    func render(_ polygon: PolygonCanvasComponent) -> any Renderable {
        let renderable = UIKitPolygon(points: polygon.points, frame: polygon.frame)
            .rotate(by: polygon.rotation)
            .zPosition(polygon.zPosition)
            .applyModifiers(modifierInfo: polygon, colorGetter: getColor)
        renderable.render(into: canvasView)
        return renderable
    }

    func render(_ image: BitmapImageCanvasComponent) -> any Renderable {
        let renderable = UIKitImageBitmap(imageResourcePath: image.imageResourcePath,
                                          center: image.center,
                                          width: image.width,
                                          height: image.height)
            .rotate(by: image.rotation)
            .zPosition(image.zPosition)
            .applyModifiers(modifierInfo: image)
        renderable.render(into: canvasView)
        return renderable
    }

    func render(_ button: ButtonCanvasComponent) -> any Renderable {
        let renderable = UIKitButton(width: button.width, height: button.height,
                                     center: button.center)
            .rotate(by: button.rotation)
            .zPosition(button.zPosition)
            .applyModifiers(modifierInfo: button)
        renderable.render(into: canvasView)
        return renderable
    }

    func render(_ joystick: JoystickCanvasComponent) -> any Renderable {
        let renderable = UIKitJoystick(center: joystick.center, radius: joystick.radius)
            .rotate(by: joystick.rotation)
            .zPosition(joystick.zPosition)
            .applyModifiers(modifierInfo: joystick)

        renderable.render(into: canvasView)
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

    private func letterboxScaleFactor(rootFrame: CGRect, canvasFrame: CGRect) -> CGFloat {
        let widthScaleFactor = rootFrame.width / canvasFrame.width
        let heightScaleFactor = rootFrame.height / canvasFrame.height
        return min(widthScaleFactor, heightScaleFactor)
    }
}
