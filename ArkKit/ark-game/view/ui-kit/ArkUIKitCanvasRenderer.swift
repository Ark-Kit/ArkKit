import UIKit

class ArkUIKitCanvasRenderer: CanvasRenderer {
    typealias ConcreteColor = UIColor

    var rootView: UIView
    var canvasFrame: CGRect
    init(rootView: UIView, canvasFrame: CGRect) {
        self.rootView = rootView
        self.canvasFrame = canvasFrame
    }

    func render(_ circle: CircleCanvasComponent) -> any Renderable {
        let (letterboxedRadius, letterboxedCenter) = letterboxCircle(canvasFrame: canvasFrame,
                                                                     center: circle.center,
                                                                     radius: circle.radius)
        let renderable = UIKitCircle(radius: letterboxedRadius, center: letterboxedCenter)
            .rotate(by: circle.rotation)
            .applyModifiers(modifierInfo: circle, colorGetter: getColor)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ rect: RectCanvasComponent) -> any Renderable {
        let letterboxedFrame = letterboxFrame(canvasFrame: canvasFrame,
                                              canvasComponentFrame: CGRect(x: rect.center.x - rect.width / 2,
                                                                           y: rect.center.y - rect.height / 2,
                                                                           width: rect.width,
                                                                           height: rect.height))
        let renderable = UIKitRect(width: letterboxedFrame.width, height: letterboxedFrame.height,
                                   center: CGPoint(x: letterboxedFrame.midX, y: letterboxedFrame.midY))
            .rotate(by: rect.rotation)
            .applyModifiers(modifierInfo: rect, colorGetter: getColor)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ polygon: PolygonCanvasComponent) -> any Renderable {
        let letterboxedFrame = letterboxFrame(canvasFrame: canvasFrame,
                                              canvasComponentFrame: polygon.frame)
        let letterboxedPoints = polygon.points.map { point in
            letterboxPoint(canvasFrame: canvasFrame, point: point)
        }
        let renderable = UIKitPolygon(points: letterboxedPoints, frame: letterboxedFrame)
            .rotate(by: polygon.rotation)
            .applyModifiers(modifierInfo: polygon, colorGetter: getColor)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ image: BitmapImageCanvasComponent) -> any Renderable {
        let letterboxedFrame = letterboxFrame(canvasFrame: canvasFrame,
                                              canvasComponentFrame: CGRect(x: image.center.x - image.width / 2,
                                                                           y: image.center.y - image.height / 2,
                                                                           width: image.width,
                                                                           height: image.height))
        let renderable = UIKitImageBitmap(imageResourcePath: image.imageResourcePath,
                                          center: CGPoint(x: letterboxedFrame.midX, y: letterboxedFrame.midY),
                                          width: letterboxedFrame.width,
                                          height: letterboxedFrame.height)
            .rotate(by: image.rotation)
            .applyModifiers(modifierInfo: image)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ button: ButtonCanvasComponent) -> any Renderable {
        let letterboxedFrame = letterboxFrame(canvasFrame: canvasFrame,
                                              canvasComponentFrame: CGRect(x: button.center.x - button.width / 2,
                                                                           y: button.center.y - button.height / 2,
                                                                           width: button.width,
                                                                           height: button.height))
        let renderable = UIKitButton(width: letterboxedFrame.width, height: letterboxedFrame.height,
                                     center: CGPoint(x: letterboxedFrame.midX, y: letterboxedFrame.midY))
            .rotate(by: button.rotation)
            .applyModifiers(modifierInfo: button)
        renderable.render(into: rootView)
        return renderable
    }

    func render(_ joystick: JoystickCanvasComponent) -> any Renderable {
        let (letterboxedRadius, letterboxedCenter) = letterboxCircle(canvasFrame: canvasFrame,
                                                                     center: joystick.center,
                                                                     radius: joystick.radius)
        let renderable = UIKitJoystick(center: letterboxedCenter, radius: letterboxedRadius)
            .rotate(by: joystick.rotation)
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

    private func letterboxFrame(canvasFrame: CGRect, canvasComponentFrame: CGRect) -> CGRect {
        let viewFrame = self.rootView.frame
        let widthScaleFactor = canvasComponentFrame.width / canvasFrame.width
        let heightScaleFactor = canvasComponentFrame.height / canvasFrame.height

        let letterboxedFrameWidth = widthScaleFactor * viewFrame.width
        let letterboxedFrameHeight = heightScaleFactor * viewFrame.height
        let letterboxedCenter = letterboxPoint(canvasFrame: canvasFrame, point: CGPoint(x: canvasComponentFrame.midX,
                                                                                        y: canvasComponentFrame.midY))
        return CGRect(x: letterboxedCenter.x - letterboxedFrameWidth / 2,
                      y: letterboxedCenter.y - letterboxedFrameHeight / 2,
                      width: letterboxedFrameWidth,
                      height: letterboxedFrameHeight)
    }
    private func letterboxCircle(canvasFrame: CGRect, center: CGPoint, radius: Double) -> (letterboxedRadius: Double,
                                                                                           letterboxedCenter: CGPoint) {
        let viewFrame = self.rootView.frame
        let radiusScaleFactor = radius / max(canvasFrame.width, canvasFrame.height)
        let letterboxedRadius = radiusScaleFactor * max(viewFrame.width, viewFrame.height)

        let letterboxedCenter = letterboxPoint(canvasFrame: canvasFrame, point: center)
        return (letterboxedRadius, letterboxedCenter)
    }
    private func letterboxPoint(canvasFrame: CGRect, point: CGPoint) -> CGPoint {
        let pointXScaleFactor = point.x / canvasFrame.midX
        let pointYScaleFactor = point.y / canvasFrame.midY
        let viewFrame = self.rootView.frame
        return CGPoint(x: pointXScaleFactor * viewFrame.midX, y: pointYScaleFactor * viewFrame.midY)
    }
}
