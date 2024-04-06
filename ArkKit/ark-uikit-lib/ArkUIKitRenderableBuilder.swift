import UIKit

class ArkUIKitRenderableBuilder: RenderableBuilder {
    typealias ConcreteColor = UIColor

    func build(_ circle: CircleRenderableComponent) -> any Renderable<UIView> {
        UIKitCircle(radius: circle.radius, center: circle.center)
            .rotate(by: circle.rotation)
            .zPosition(circle.zPosition)
            .setIsUserInteractionEnabled(circle.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: circle, colorGetter: getColor)
    }

    func build(_ rect: RectRenderableComponent) -> any Renderable<UIView> {
        UIKitRect(width: rect.width, height: rect.height, center: rect.center)
            .rotate(by: rect.rotation)
            .zPosition(rect.zPosition)
            .setIsUserInteractionEnabled(rect.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: rect, colorGetter: getColor)
    }

    func build(_ polygon: PolygonRenderableComponent) -> any Renderable<UIView> {
        UIKitPolygon(points: polygon.points, frame: polygon.frame)
            .rotate(by: polygon.rotation)
            .zPosition(polygon.zPosition)
            .setIsUserInteractionEnabled(polygon.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: polygon, colorGetter: getColor)
    }

    func build(_ image: BitmapImageRenderableComponent) -> any Renderable<UIView> {
        UIKitImageBitmap(imageResourcePath: image.imageResourcePath,
                         center: image.center,
                         width: image.width,
                         height: image.height)
        .rotate(by: image.rotation)
        .zPosition(image.zPosition)
        .setIsUserInteractionEnabled(image.isUserInteractionEnabled)
        .applyModifiers(modifierInfo: image)
    }

    func build(_ button: ButtonRenderableComponent) -> any Renderable<UIView> {
        UIKitButton(width: button.width, height: button.height, center: button.center)
            .rotate(by: button.rotation)
            .zPosition(button.zPosition)
            .setIsUserInteractionEnabled(button.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: button)
            .style(button.buttonStyleConfig, colorGetter: getColor)
    }

    func build(_ joystick: JoystickRenderableComponent) -> any Renderable<UIView> {
        UIKitJoystick(center: joystick.center, radius: joystick.radius)
            .rotate(by: joystick.rotation)
            .zPosition(joystick.zPosition)
            .setIsUserInteractionEnabled(joystick.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: joystick)
    }

    func build(_ container: CameraContainerRenderableComponent) -> any Renderable<UIView> {
        UIKitCamera(frame: container.frame)
            .zPosition(container.zPosition)
            .rotate(by: container.rotation)
            .setIsUserInteractionEnabled(container.isUserInteractionEnabled)
            .addToContainer(
                container.renderableComponents.map { comp in
                    comp.buildRenderable(using: self)
                }
            )
            .scaleFromOrigin(byWidth: container.zoom.widthZoom, byHeight: container.zoom.heightZoom)
            .scaleFromOrigin(byWidth: container.letterboxWidthScaleFactor,
                             byHeight: container.letterboxHeightScaleFactor)
            .setMask(container.mask, on: container.trackPosition)
    }

    let defaultColor: UIColor = .black
    let colorMapping: [AbstractColor: UIColor] = [
        .default: .clear,
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
