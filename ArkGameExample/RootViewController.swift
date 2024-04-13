import UIKit

class RootViewController: UINavigationController {
    override func viewDidLoad() {
        let homePage = ArkDemoHomePage()
        homePage.rootViewControllerDelegate = self
        self.pushViewController(homePage, animated: false)
    }
}

protocol RootViewControllerDelegate: AnyObject {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

extension RootViewController: RootViewControllerDelegate { }
