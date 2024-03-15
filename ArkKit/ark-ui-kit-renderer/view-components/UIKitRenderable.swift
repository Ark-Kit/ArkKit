import UIKit

protocol UIKitRenderable: UIView, Renderable {
}

extension UIKitRenderable {
    func render(into container: UIView) {
        container.addSubview(self)
    }
}
