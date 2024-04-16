struct ArkAnimationsComponent: Component {
    var animations: [any AnimationInstance] = []

    @discardableResult mutating func addAnimation(_ animation: any AnimationInstance) -> Self {
        animations.append(animation)
        return self
    }

    @discardableResult mutating func removeAnimation(_ animation: any AnimationInstance) -> Self {
        animations.removeAll { $0 === animation }
        return self
    }
}
