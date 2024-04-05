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
        for subview in self.subviews {
            let convertedFrame = subview.convert(subview.bounds, to: self)
            subview.frame = convertedFrame
        }
        return self
    }

    func clipToBounds() -> Self {
        self.clipsToBounds = true
        return self
    }

    func scale(by scaleFactor: CGFloat) -> Self {
        self.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        // Adjust the position of each subview
        for subview in self.subviews {
            // Convert the subview's frame to the container's coordinate system
            let convertedFrame = subview.convert(subview.bounds, to: self)

            // Calculate the new position based on the scaling factor
            let newFrame = CGRect(x: convertedFrame.origin.x * scaleFactor,
                                  y: convertedFrame.origin.y * scaleFactor,
                                  width: convertedFrame.size.width * scaleFactor,
                                  height: convertedFrame.size.height * scaleFactor)

            // Apply the new frame
            subview.frame = newFrame
        }
        return self
    }

    func setMask(_ maskFrame: CGRect?) -> Self {
        guard let maskFrame = maskFrame else {
            return self
        }
        let maskView = UIView(frame: maskFrame)
        maskView.backgroundColor = .blue
        self.mask = maskView
        return self
    }
}
