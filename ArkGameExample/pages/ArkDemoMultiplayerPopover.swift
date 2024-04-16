import UIKit

class ArkDemoMultiplayerPopover: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var onJoin: ((String?) -> Void)?
    var onStart: ((String?) -> Void)?
    let options = ["Multiplayer Local", "Multiplayer Distributed"]
    let roomNames = ["CuteDolphin", "SmartKite", "FlatRock", "OddPony", "SillyKoala"]
    var selectedOption: String? = "Multiplayer Local"
    var isShowingOptions = true

    private let pickerView = UIPickerView()
    private let arrowButton = UIButton(type: .system)
    private let joinButton = UIButton(type: .system)
    private let hostButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupButtonAction()
        joinButton.isHidden = true
        hostButton.isHidden = true
    }

    private func setupUI() {
        view.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false

        arrowButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        hostButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.setTitle("Join Session", for: .normal)
        hostButton.setTitle("Start Session", for: .normal)
        view.addSubview(arrowButton)
        view.addSubview(joinButton)
        view.addSubview(hostButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            arrowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            joinButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            joinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            hostButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    private func setupButtonAction() {
        arrowButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        hostButton.addTarget(self, action: #selector(startSession), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        isShowingOptions ? options.count : roomNames.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        isShowingOptions ? options[row] : roomNames[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = isShowingOptions ? options[row] : roomNames[row]
    }

    @objc func buttonClick() {
        if selectedOption == options[0] {
            dismiss(animated: true) {
                self.onStart?(nil)
            }
            return
        }

        isShowingOptions.toggle()
        pickerView.reloadAllComponents()
        joinButton.isHidden = false
        hostButton.isHidden = false
        arrowButton.isHidden = true

        if Set(roomNames).contains(selectedOption) {
            guard let _ = selectedOption else {
                return
            }
        }
        guard let indexSelected = options.firstIndex(where: { val in val == selectedOption }) else {
            return
        }
        if indexSelected < roomNames.count {
            selectedOption = roomNames[indexSelected]
        }
    }
    @objc func startSession() {
        guard let roomName = selectedOption else {
            return
        }
        print("start room", roomName)
        dismiss(animated: true) {
            self.onStart?(roomName)
        }
    }
    @objc func joinSession() {
        guard let roomName = selectedOption else {
            return
        }
        print("join room", roomName)
        dismiss(animated: true) {
            self.onJoin?(roomName)
        }
    }
}
