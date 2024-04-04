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

    func clipToBounds() -> Self {
        self.clipsToBounds = true
        return self
    }
}
