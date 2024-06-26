import UIKit

public class ArkUIKitRenderableBuilder: RenderableBuilder {
    public typealias ConcreteColor = UIColor

    public func build(_ circle: CircleRenderableComponent) -> any Renderable<UIView> {
        UIKitCircle(radius: circle.radius, center: circle.center)
            .rotate(by: circle.rotation)
            .zPosition(circle.zPosition)
            .opacity(circle.opacity)
            .setIsUserInteractionEnabled(circle.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: circle, colorGetter: getColor)
    }

    public func build(_ rect: RectRenderableComponent) -> any Renderable<UIView> {
        UIKitRect(width: rect.width, height: rect.height, center: rect.center)
            .rotate(by: rect.rotation)
            .zPosition(rect.zPosition)
            .opacity(rect.opacity)
            .setIsUserInteractionEnabled(rect.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: rect, colorGetter: getColor)
    }

    public func build(_ polygon: PolygonRenderableComponent) -> any Renderable<UIView> {
        UIKitPolygon(points: polygon.points, frame: polygon.frame)
            .rotate(by: polygon.rotation)
            .zPosition(polygon.zPosition)
            .opacity(polygon.opacity)
            .setIsUserInteractionEnabled(polygon.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: polygon, colorGetter: getColor)
    }

    public func build(_ image: BitmapImageRenderableComponent) -> any Renderable<UIView> {
        UIKitImageBitmap(imageResourcePath: image.imageResourcePath,
                         center: image.center,
                         width: image.width,
                         height: image.height)
        .rotate(by: image.rotation)
        .zPosition(image.zPosition)
        .opacity(image.opacity)
        .setIsUserInteractionEnabled(image.isUserInteractionEnabled)
        .applyModifiers(modifierInfo: image)
    }

    public func build(_ button: ButtonRenderableComponent) -> any Renderable<UIView> {
        UIKitButton(width: button.width, height: button.height, center: button.center)
            .rotate(by: button.rotation)
            .zPosition(button.zPosition)
            .opacity(button.opacity)
            .setIsUserInteractionEnabled(button.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: button)
            .style(button.buttonStyleConfig, colorGetter: getColor)
    }

    public func build(_ joystick: JoystickRenderableComponent) -> any Renderable<UIView> {
        UIKitJoystick(center: joystick.center, radius: joystick.radius)
            .rotate(by: joystick.rotation)
            .zPosition(joystick.zPosition)
            .opacity(joystick.opacity)
            .setIsUserInteractionEnabled(joystick.isUserInteractionEnabled)
            .applyModifiers(modifierInfo: joystick)
    }

    public func build(_ container: CameraContainerRenderableComponent) -> any Renderable<UIView> {
        UIKitCamera(frame: container.frame)
            .zPosition(container.zPosition)
            .rotate(by: container.rotation)
            .opacity(container.opacity)
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

    public let defaultColor: UIColor = .black
    public let colorMapping: [AbstractColor: UIColor] = [
        .default: .clear,
        .blue: .blue,
        .red: .red,
        .green: .green,
        .black: .black,
        .gray: .gray,
        .white: .white,
        .transparent: .clear
    ]

    private func letterboxScaleFactor(rootFrame: CGRect, canvasFrame: CGRect) -> CGFloat {
        let widthScaleFactor = rootFrame.width / canvasFrame.width
        let heightScaleFactor = rootFrame.height / canvasFrame.height
        return min(widthScaleFactor, heightScaleFactor)
    }
}
