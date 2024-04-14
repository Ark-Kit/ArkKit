import UIKit

class ArkDemoMultiplayerPopover: UIViewController {
    var onJoin: (() -> Void)?
    var onStart: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        preferredContentSize = CGSize(width: 300, height: 200)

        setupButtons()
    }

    private func setupButtons() {
        let joinButton = UIButton(type: .system)
        joinButton.setTitle("Start Multiplayer Game", for: .normal)
        joinButton.translatesAutoresizingMaskIntoConstraints = false

        let startButton = UIButton(type: .system)
        startButton.setTitle("Join Multiplayer Game", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(joinButton)
        view.addSubview(startButton)

        joinButton.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25),
            joinButton.widthAnchor.constraint(equalToConstant: 200),
            joinButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: 20),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func joinTapped() {
        dismiss(animated: true) {
            self.onJoin?()
        }
    }

    @objc func startTapped() {
        dismiss(animated: true) {
            self.onStart?()
        }
    }
}
