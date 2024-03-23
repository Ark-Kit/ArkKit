import UIKit

class ArkUIKitCanvasRenderer: CanvasRenderer {
    typealias ConcreteColor = UIColor

    var rootView: UIView
    var canvasView: UIView

    private func getParentView(layer: RenderLayer) -> UIView {
        switch layer {
        case .canvas:
            return canvasView
        case .screen:
            return rootView
        }
    }

    init(rootView: UIView, canvasView: UIView, canvasFrame: CGRect) {
        self.rootView = rootView
        self.canvasView = canvasView
        // Scale canvasView to fit the rootView
        let scaleFactor = letterboxScaleFactor(rootFrame: rootView.frame, canvasFrame: canvasFrame)

        canvasView.bounds = canvasFrame
        canvasView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        canvasView.center = rootView.center
    }

    func render(_ circle: CircleRenderableComponent) -> any Renderable {
        UIKitCircle(radius: circle.radius, center: circle.center)
            .rotate(by: circle.rotation)
            .zPosition(circle.zPosition)
            .setIsUserInteractionEnabled(circle.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: circle, colorGetter: getColor)
    }

    func render(_ rect: RectRenderableComponent) -> any Renderable {
        UIKitRect(width: rect.width, height: rect.height, center: rect.center)
            .rotate(by: rect.rotation)
            .zPosition(rect.zPosition)
            .setIsUserInteractionEnabled(rect.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: rect, colorGetter: getColor)
    }

    func render(_ polygon: PolygonRenderableComponent) -> any Renderable {
        UIKitPolygon(points: polygon.points, frame: polygon.frame)
            .rotate(by: polygon.rotation)
            .zPosition(polygon.zPosition)
            .setIsUserInteractionEnabled(polygon.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: polygon, colorGetter: getColor)
    }

    func render(_ image: BitmapImageRenderableComponent) -> any Renderable {
        UIKitImageBitmap(imageResourcePath: image.imageResourcePath,
                         center: image.center,
                         width: image.width,
                         height: image.height)
        .rotate(by: image.rotation)
        .zPosition(image.zPosition)
        .setIsUserInteractionEnabled(image.isUserInteractionEnabled)
        .applyModifiers(modifierInfo: image)
    }

    func render(_ button: ButtonRenderableComponent) -> any Renderable {
        UIKitButton(width: button.width, height: button.height, center: button.center)
            .rotate(by: button.rotation)
            .zPosition(button.zPosition)
            .setIsUserInteractionEnabled(button.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: button)
    }

    func render(_ joystick: JoystickRenderableComponent) -> any Renderable {
        UIKitJoystick(center: joystick.center, radius: joystick.radius)
            .rotate(by: joystick.rotation)
            .zPosition(joystick.zPosition)
            .setIsUserInteractionEnabled(joystick.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: joystick)
    }

    func upsertToView<T: Renderable>(_ renderable: T, at renderLayer: RenderLayer) {
        guard let layer = getParentView(layer: renderLayer) as? T.Container else {
            return
        }
        renderable.render(into: layer)
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
