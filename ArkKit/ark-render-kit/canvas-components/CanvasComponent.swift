import Foundation

protocol CanvasComponent: Component, Memoizable {
    var center: CGPoint { get set }
    var rotation: Double { get set }
    func render(using renderer: any CanvasRenderer) -> any Renderable
    func update(using updater: any CanvasComponentUpdater) -> Self
    
    func center(x: Double?, y: Double?) -> Self
    func center(_ center: CGPoint) -> Self
    func rotation(_ rotation: Double) -> Self
}

extension CanvasComponent {
    func center(x: Double?, y: Double?) -> Self {
        var newSelf = self
        newSelf.center = CGPoint(x: x ?? center.x, y: y ?? center.y)
        return newSelf
    }
    
    func center(_ center: CGPoint) -> Self {
        var newSelf = self
        newSelf.center = center
        return newSelf
    }
    
    func rotation(_ rotation: Double) -> Self {
        var newSelf = self
        newSelf.rotation = rotation
        return newSelf
    }
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
