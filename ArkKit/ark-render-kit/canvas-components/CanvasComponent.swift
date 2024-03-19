protocol CanvasComponent: Component, Memoizable {
    func render(using renderer: any CanvasRenderer) -> any Renderable
}

protocol Memoizable {
    typealias AreValuesEqualDelegate = (_: Self, _: Self) -> Bool
    var areValuesEqual: AreValuesEqualDelegate { get }
    func hasUpdated(previous: any CanvasComponent) -> Bool
}

extension CanvasComponent {
    func hasUpdated(previous: any CanvasComponent) -> Bool {
        guard let previousComp = previous as? Self else {
            return true
        }
        return !areValuesEqual(self, previousComp)
    }
}
