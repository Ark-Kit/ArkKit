import UIKit

protocol UIKitRenderable: Renderable where Container == UIView {
    var uiView: UIView { get }
}

extension UIKitRenderable {
    func render(into container: UIView) {
        container.addSubview(uiView)
    }
}
