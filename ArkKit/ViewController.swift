import UIKit

class ViewController: UIViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let midX = view.frame.midX
        let midY = view.frame.midY
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true

        let joystick = UIKitJoystick(center: CGPoint(x: midX, y: midY), radius: 50)
        joystick.render(into: self.view)
        var arkBlueprint = ArkBlueprint()
        arkBlueprint.rules(on: DemoArkEvent.self, then: Forever { event, _, ecsContext in
            guard event is DemoArkEvent else {
                print("in gaurd")
                return
            }
            // dev can mutate ecs via here
            print(ecsContext.getEntities(with: []))
        })
        print("blueprint", arkBlueprint)
        let ark = Ark(rootView: UINavigationController())
        ark.start(blueprint: arkBlueprint)
        var demoEvent: any ArkEvent = DemoArkEvent()
        ark.eventContext.emit(&demoEvent)
        print("emitting first event", demoEvent)
        ark.eventContext.processEvents()
        print("emitting second event", demoEvent)
        ark.eventContext.emit(&demoEvent)
        ark.eventContext.processEvents()
    }
}
