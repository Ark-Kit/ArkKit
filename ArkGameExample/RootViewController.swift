import UIKit

class RootViewController: UINavigationController {
}

extension RootViewController: AbstractParentView {
    func pushView(_ view: any AbstractChildView, animated: Bool) {
        guard let castedViewController = view as? UIViewController else {
            return
        }
        self.pushViewController(castedViewController, animated: animated)
    }
}
