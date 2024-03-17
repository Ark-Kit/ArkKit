/**
 * Devs should only use `ArkBlueprint` to defining the rules, events, and inputs.
 *
 * `ArkBlueprint` is effectively the blueprint struct that will be read to return an `Ark` game instance.
 */
struct ArkBlueprint {
    private(set) var rules: [Rule] = []
    func rules<Event: ArkEvent>(on eventType: Event.Type,
                                         then action: Action) -> ArkBlueprint {
        var rulesCopy = rules
        rulesCopy.append(Rule(event: Event.id, action: action))
        return ArkBlueprint(rules: rulesCopy)
    }
}
