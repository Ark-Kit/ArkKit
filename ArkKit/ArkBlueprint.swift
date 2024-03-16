/**
 * Devs should only use `ArkBlueprint` to defining the rules, events, and inputs.
 *
 * `ArkBlueprint` is effectively the blueprint struct that will be read to return an `Ark` game instance.
 */
struct ArkBlueprint {
    private(set) var rules: [Rule] = []
    mutating func rules<Event: ArkEvent>(on eventType: Event.Type,
                                         then action: Action) -> Self {
        rules.append(Rule(event: Event.id, action: action))
        return self
    }
}
