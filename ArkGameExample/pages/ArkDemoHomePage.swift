import UIKit

class ArkDemoHomePage: UIViewController {
    weak var rootViewControllerDelegate: RootViewControllerDelegate?

    let titleView: UIImageView = {
        let image = UIImage(named: "ArkKit-Logo-Transparent")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BABY_BEIGE

        setUpLogo()
        setUpGameMenu()
    }

    func setUpLogo() {
        self.view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -240.0),
            titleView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

    func setUpGameMenu() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        for game in DemoGames.allCases {
            let button = UIButton(type: .system)
            button.setTitle(game.rawValue, for: .normal)
            button.setTitleColor(DARK_GRAY, for: .normal)

            var buttonConfig = UIButton.Configuration.filled()
            buttonConfig.contentInsets =
                    NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16) // Padding
            buttonConfig.background.cornerRadius = 8

            buttonConfig.background.backgroundColor = LIGHT_BLUE

            // font style
            buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { container in
                var copy = container
                copy.font = UIFont(name: "Avenir-Medium", size: 24)
                return copy
            }

            button.addTarget(self, action: #selector(gameButtonTapped(_:)), for: .touchUpInside)
            button.configuration = buttonConfig

            button.translatesAutoresizingMaskIntoConstraints = false

            stackView.addArrangedSubview(button)
        }
    }

    @objc func gameButtonTapped(_ sender: UIButton) {
        guard let gameOption = (sender.superview as? UIStackView)?.arrangedSubviews.firstIndex(of: sender) else {
            return
        }

        let gameType = DemoGames.allCases[gameOption]
        if let parentDelegate = self.rootViewControllerDelegate {
            GameHostingPageFactory.loadGame(from: gameType, with: parentDelegate,
                                            sourceView: sender, sourceRect: sender.bounds)
        }
    }
}
