import UIKit

final class UIKitContainer: UIView, UIKitRenderable {
    var renderableComponents: [any RenderableComponent] = []

    func addToContainer(_ renderables: [any Renderable<UIView>]) -> Self {
        for renderable in renderables {
            guard let viewComp = renderable as? any UIKitRenderable else {
                continue
            }
            self.addSubview(viewComp)
        }
        return self
    }

    func scaleFromOrigin(byWidth widthScaleFactor: CGFloat, byHeight heightScaleFactor: CGFloat) -> Self {
        self.transform = self.transform.scaledBy(x: widthScaleFactor, y: heightScaleFactor)
        self.frame.origin = CGPoint.zero
        return self
    }

    func setMask(_ maskFrame: CGRect?, on focusCenter: CGPoint? = nil) -> Self {
        guard let mask = maskFrame else {
            return self
        }

        guard let focus = focusCenter else {
            return self
        }

        self.center.x += mask.midX - focus.applying(self.transform).x
        self.center.y += mask.midY - focus.applying(self.transform).y

        let maskView = UIView(frame: mask)
        let convertedMaskFrame = maskView.convert(maskView.bounds, to: self)
        maskView.frame = convertedMaskFrame
        // any opaque color
        // reference: https://developer.apple.com/documentation/uikit/uiview/1622557-mask
        maskView.backgroundColor = .blue
        self.mask = maskView
        return self
    }
}
