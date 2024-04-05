import Foundation

protocol RenderableComponent: Component, Memoizable {
    typealias ShouldRerenderDelegate = (_ old: Self, _ new: Self) -> Bool

    var center: CGPoint { get set }
    var rotation: Double { get set }
    var zPosition: Double { get set }
    var renderLayer: RenderLayer { get set }
    var isUserInteractionEnabled: Bool { get set }
    var shouldRerenderDelegate: ShouldRerenderDelegate? { get set }

    func buildRenderable<T>(using builder: any RenderableBuilder<T>) -> any Renderable<T>

    func center(x: Double?, y: Double?) -> Self
    func center(_ center: CGPoint) -> Self
    func rotation(_ rotation: Double) -> Self
    func zPosition(_ zPos: Double) -> Self
    func layer(_ layer: RenderLayer) -> Self
    func userInteractionsEnabled(_ isEnabled: Bool) -> Self
    func shouldRerender(_ shouldRerender: @escaping ShouldRerenderDelegate) -> Self
}

extension RenderableComponent {
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

    func zPosition(_ zPos: Double) -> Self {
        var newSelf = self
        newSelf.zPosition = zPos
        return newSelf
    }

    func userInteractionsEnabled(_ isEnabled: Bool) -> Self {
        var newSelf = self
        newSelf.isUserInteractionEnabled = isEnabled
        return newSelf
    }

    func layer(_ layer: RenderLayer) -> Self {
        var newSelf = self
        newSelf.renderLayer = layer
        return newSelf
    }

    func shouldRerender(_ shouldRerenderDelegate: @escaping ShouldRerenderDelegate) -> Self {
        var newSelf = self
        newSelf.shouldRerenderDelegate = shouldRerenderDelegate
        return newSelf
    }

    var areValuesEqual: AreValuesEqualDelegate {
        { old, new in
            if let shouldRerenderDelegate {
                return !shouldRerenderDelegate(old, new)
            }
            return false
        }
    }
}

protocol Memoizable {
    typealias AreValuesEqualDelegate = (_: Self, _: Self) -> Bool
    var areValuesEqual: AreValuesEqualDelegate { get }
    func hasUpdated(previous: any Memoizable) -> Bool
}

extension RenderableComponent {
    func hasUpdated(previous: any Memoizable) -> Bool {
        guard let previousComp = previous as? Self else {
            return true
        }
        return !areValuesEqual(self, previousComp)
    }
}
