import UIKit

final class UIKitCamera: UIView, UIKitRenderable {
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

        // Translate to center mask onto focus
        self.center.x += mask.midX - focus.applying(self.transform).x
        self.center.y += mask.midY - focus.applying(self.transform).y

        if self.frame.maxY < mask.maxY {
            self.center.y += mask.maxY - self.frame.maxY
        }
        if self.frame.maxX < mask.maxX {
            self.center.x += mask.maxX - self.frame.maxX
        }
        if self.frame.minX > mask.minX {
            self.center.x += mask.minX - self.frame.minX
        }
        if self.frame.minY > mask.minY {
            self.center.y += mask.minY - self.frame.minY
        }

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
