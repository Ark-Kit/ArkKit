protocol ButtonHandlerDelegate: AnyObject {
    func onTap()
    // any other input behaviours
    // we support on the button view component
}

protocol JoyStickHandlerDelegate: AnyObject {
    func onPanStart()
    func onPanChange()
    func onPanEnd()
    // any other input behaviours
    // we support on the joystick view component
}

protocol LayoutHandlerDelegate: AnyObject {
    func onTap()
    func onLongPress()
    // any other input behaviours we support
    // on the board layout.
}
