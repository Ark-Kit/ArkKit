public struct ArkAnimationsComponent: Component {
    public var animations: [any AnimationInstance] = []

    public init() {}

    @discardableResult
    public mutating func addAnimation(_ animation: any AnimationInstance) -> Self {
        animations.append(animation)
        return self
    }

    @discardableResult
    public mutating func removeAnimation(_ animation: any AnimationInstance) -> Self {
        animations.removeAll { $0 === animation }
        return self
    }
}
