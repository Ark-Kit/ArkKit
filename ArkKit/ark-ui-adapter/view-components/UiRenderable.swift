import UIKit

protocol UiRenderable {
    var uiView: UIView { get }
    func render(into containerView: UIView)
}

extension UiRenderable {
    func render(into containerView: UIView) {
        containerView.addSubview(uiView)
    }
}
