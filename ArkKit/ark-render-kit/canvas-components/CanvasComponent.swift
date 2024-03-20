import Foundation

protocol CanvasComponent: Component, Memoizable {
    var center: CGPoint { get }
    var rotation: Double { get }
    func render(using renderer: any CanvasRenderer) -> any Renderable
    func update(using updater: any CanvasComponentUpdater) -> Self
}

protocol Memoizable {
    typealias AreValuesEqualDelegate = (_: Self, _: Self) -> Bool
    var areValuesEqual: AreValuesEqualDelegate { get }
    func hasUpdated(previous: any Memoizable) -> Bool
}

extension CanvasComponent {
    func hasUpdated(previous: any Memoizable) -> Bool {
        guard let previousComp = previous as? Self else {
            return true
        }
        return !areValuesEqual(self, previousComp)
    }
}
