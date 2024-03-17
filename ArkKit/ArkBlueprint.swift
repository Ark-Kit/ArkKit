/**
 * Devs should only use `ArkBlueprint` to defining the rules, events, and inputs.
 *
 * `ArkBlueprint` is effectively the blueprint struct that will be read to return an `Ark` game instance.
 */
struct ArkBlueprint {
    private(set) var rules: [Rule] = []
    private(set) var animations: [ArkAnimation<Any>] = []

    func rules<Event: ArkEvent>(on eventType: Event.Type,
                                then action: Action) -> ArkBlueprint {
        var rulesCopy = rules
        rulesCopy.append(Rule(event: Event.id, action: action))
        return immutableCopy(rules: rulesCopy)
    }

    func animation(_ animation: ArkAnimation<Any>) -> ArkBlueprint {
        var animationsCopy = animations
        animationsCopy.append(animation)
        return immutableCopy(animations: animationsCopy)
    }

    private func immutableCopy(rules: [Rule]? = nil, animations: [ArkAnimation<Any>]? = nil) -> ArkBlueprint {
        ArkBlueprint(rules: rules ?? self.rules,
                     animations: animations ?? self.animations)
    }
}
