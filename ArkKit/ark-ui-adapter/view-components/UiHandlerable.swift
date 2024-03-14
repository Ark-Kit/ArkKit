import UIKit

protocol UiHandlerable {
    func addHandlerDelegate<T: AbstractViewHandlerDelegate>(_ handlerDelegate: T)
}

class ButtonHandler {
    private(set) var uiView: UIButton
    var delegate: ButtonCommandDelegate?
    init() {
        self.uiView = UIButton()
    }
    @objc func handleTap() {
        delegate?.onTap()
    }
    func addHandlerDelegate(_ buttonHandlerDelegate: ButtonCommandDelegate) {
        self.delegate = buttonHandlerDelegate
        self.registerTapGestureRecognizer()
    }
    private func registerTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap))
        uiView.addGestureRecognizer(tapGestureRecognizer)
    }
}
