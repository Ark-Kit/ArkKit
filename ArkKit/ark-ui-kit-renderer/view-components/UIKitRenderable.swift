import UIKit

protocol UIKitRenderable: UIView, Renderable {
}

extension UIKitRenderable {
    func render(into container: UIView) {
        container.addSubview(self)
    }

    func `if`(_ condition: Bool, transform: (Self) -> Self) -> Self {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
