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
//        let button = UIKitButton(width: 100, height: 100, center: CGPoint(x: midX, y: midY))
//        button.backgroundColor = .red
//        button.render(into: self.view)
    }
}
