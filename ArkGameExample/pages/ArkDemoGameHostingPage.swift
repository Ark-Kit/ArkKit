import UIKit

protocol AbstractDemoGameHostingPage: UIViewController { }

class ArkDemoGameHostingPage<T: ArkExternalResources>: UIViewController {
    var ark: Ark<UIView, T>?
    var shouldShowMultiplayerOptions = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if shouldShowMultiplayerOptions {
            presentMultiplayerOptions()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ark?.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ark?.finish()
        ark = nil
    }

    private func presentMultiplayerOptions() {
        let popover = ArkDemoMultiplayerPopover()
        popover.modalPresentationStyle = .overFullScreen
        self.present(popover, animated: true)
    }
}

extension ArkDemoGameHostingPage: AbstractRootView {
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
        self.addChild(castedViewController)
        castedViewController.view.frame = self.view.bounds
        self.view.addSubview(castedViewController.view)
        castedViewController.didMove(toParent: self)
    }
}

extension ArkDemoGameHostingPage: AbstractDemoGameHostingPage { }
