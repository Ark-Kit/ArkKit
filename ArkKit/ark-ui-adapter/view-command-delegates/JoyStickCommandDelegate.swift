protocol JoyStickCommandDelegate: AbstractViewCommandDelegate {
    func onPanStart()
    func onPanChange()
    func onPanEnd()
    // any other input behaviours
    // we support on the joystick view component
}
