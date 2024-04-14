import UIKit

class TankWinCustomView: UIViewController {

    var winner: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupSubviews()
    }

    func setupSubviews() {
        // Container view
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        view.addSubview(containerView)

        // Winner label
        let winnerLabel = UILabel()
        winnerLabel.text = "Winner: \(winner ?? "Unknown")"
        winnerLabel.textAlignment = .center
        winnerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        containerView.addSubview(winnerLabel)

        // Back button
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        containerView.addSubview(backButton)

        // Layout
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 200)
        ])

        winnerLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            winnerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            winnerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            winnerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            backButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            backButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
