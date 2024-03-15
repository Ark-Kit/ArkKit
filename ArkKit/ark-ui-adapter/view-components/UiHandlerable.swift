import UIKit

protocol UiHandlerable {
    func addHandlerDelegate<T: AbstractViewCommandDelegate>(_ handlerDelegate: T)
}

class ButtonHandler {
    private(set) var uiView: UIButton
    var delegate: ButtonCommandDelegate?
    // var eventQueue: ??? --> how does the dev know where the eventManager is?
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

// expose to dev the command delegates
// event queue
// list of events or action to add

// method 1
// Ark.buttonSetup([1: ArkShootBallEvent]) {
//     <Button onclick={() => em.emit(dict[1])} />
//    let shootballcommand = ShootBallCommand(() -> EventManager.emit(ArkShootBallEvent))
// }
class ShootBallCommand: ButtonCommandDelegate {
    func onTap() {
        // expose some client over the event queue
        // does buttoncommanddelegate know the queue?
        // eventManager.emit("shootball")
    }
}

/**
 *
 * Ark.rules(on: "shootball", then: () => {} )
 * let buttonCommandDelegate = ButtonCommandDelegate()
 * let event = ActionEvent()
 * let delegate = ButtonDelegate()
 * let button = ButtonHandler()
 *
 * Ark.buttonSetUp(_ event) {
 *     em.emit(event)
 * }
 *
 * Ark.buttonSetup(ButtonType, handler, position) {
 *
 * }
 */

/**
 * UIKit - specific
 *  View rendered ->
 */
