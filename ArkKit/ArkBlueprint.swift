/**
 * Devs should only use `ArkBlueprint` to defining the rules, events, and inputs.
 *
 * `ArkBlueprint` is effectively the blueprint struct that will be read to return an `Ark` game instance.
 */
struct ArkBlueprint {
    private(set) var rules: [Rule] = []
    private(set) var setupFunctions: [ArkStateSetupFunction] = []

    private(set) var frameWidth: Double
    private(set) var frameHeight: Double

    func setup(_ fn: @escaping ArkStateSetupFunction) -> Self {
        var stateSetupFunctionsCopy = setupFunctions
        stateSetupFunctionsCopy.append(fn)

        var newSelf = self
        newSelf.setupFunctions = stateSetupFunctionsCopy
        return newSelf
    }

    func rule<Event: ArkEvent>(
        on eventType: Event.Type,
        then action: Action
    ) -> Self {
        var newRules = rules
        newRules.append(Rule(event: Event.id, action: action))

        var newSelf = self
        newSelf.rules = newRules
        return newSelf
    }
}
