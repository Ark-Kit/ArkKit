import UIKit

protocol AbstractDemoGameHostingPage: UIViewController { }

class ArkDemoGameHostingPage<T: ArkExternalResources>: UIViewController {
    // inject blueprint here
    var arkBlueprint: ArkBlueprint<T>?
    var ark: Ark<UIView, T>?
    var shouldShowMultiplayerOptions = false

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let blueprint = arkBlueprint else {
            return
        }

        if shouldShowMultiplayerOptions {
            presentMultiplayerOptions()
        }

        // Example on how to inject views into ark blueprint after win/ termination
//        arkBlueprint = arkBlueprint?.on(TerminateGameLoopEvent.self) { event, context in
//            // add pop-up view here
//            self.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>)
//        }

        // load blueprint
        ark = Ark(rootView: self, blueprint: blueprint)
        ark?.start()
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
