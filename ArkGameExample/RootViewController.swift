import UIKit

class RootViewController: UINavigationController {
}

extension RootViewController: AbstractRootView {
    var abstractView: UIView {
        self.view
    }

    var size: CGSize {
        view.frame.size
    }

    func pushView(_ view: any AbstractView<UIView>, animated: Bool) {
        guard let castedViewController = view as? UIViewController else {
            return
        }
        self.pushViewController(castedViewController, animated: animated)
    }
}
