import UIKit

class RootViewController: UINavigationController, UIPopoverPresentationControllerDelegate {
    override func viewDidLoad() {
        let homePage = ArkDemoHomePage()
        homePage.rootViewControllerDelegate = self
        self.pushViewController(homePage, animated: false)
    }
}

protocol RootViewControllerDelegate: AnyObject {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func presentPopover(_ popoverViewController: UIViewController, sourceView: UIView,
                        sourceRect: CGRect, animated: Bool)
}

extension RootViewController: RootViewControllerDelegate {
    func presentPopover(_ popoverViewController: UIViewController, sourceView: UIView, sourceRect: CGRect, animated: Bool) {
        popoverViewController.modalPresentationStyle = .popover
        if let popoverPresentationController = popoverViewController.popoverPresentationController {
            popoverPresentationController.sourceView = sourceView
            popoverPresentationController.sourceRect = sourceRect
            popoverPresentationController.permittedArrowDirections = .any
            popoverPresentationController.delegate = self
        }
        present(popoverViewController, animated: animated)
    }
}
