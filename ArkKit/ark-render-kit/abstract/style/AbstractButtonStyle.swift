enum ButtonState {
    case normal
    case highlighted
    case disabled
    case selected
    case focused
}

protocol AbstractButtonStyle {
    func label(_ label: String,
               color: AbstractColor) -> Self
    func background(color: AbstractColor) -> Self
    func borderRadius(_ radius: Double) -> Self
    func borderWidth(_ value: Double) -> Self
    func borderColor(_ color: AbstractColor) -> Self
    func padding(_ padding: Double) -> Self
    func padding(x: Double, y: Double) -> Self
    func padding(top: Double, bottom: Double, left: Double, right: Double) -> Self
}
