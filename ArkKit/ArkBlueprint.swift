/**
 * Devs should only use `ArkBlueprint` to defining the rules, events, and inputs.
 *
 * `ArkBlueprint` is effectively the blueprint struct that will be read to return an `Ark` game instance.
 */
struct ArkBlueprint {
    private(set) var rules: [Rule] = []
    private(set) var stateSetupFunctions: [ArkStateSetupFunction] = []

    private(set) var frameWidth: Double
    private(set) var frameHeight: Double

    func rule<Event: ArkEvent>(
        on eventType: Event.Type,
        then action: Action
    ) -> ArkBlueprint {
        var rulesCopy = rules
        rulesCopy.append(Rule(event: Event.id, action: action))
        return immutableCopy(rules: rulesCopy)
    }

    func stateSetup(_ fn: @escaping ArkStateSetupFunction) -> ArkBlueprint {
        var stateSetupFunctionsCopy = stateSetupFunctions
        stateSetupFunctionsCopy.append(fn)
        return immutableCopy(stateSetupFunctions: stateSetupFunctionsCopy)
    }

    private func immutableCopy(
        rules: [Rule]? = nil,
        stateSetupFunctions: [ArkStateSetupFunction]? = nil,
        frameWidth: Double? = nil,
        frameHeight: Double? = nil
    ) -> ArkBlueprint {
        ArkBlueprint(
            rules: rules ?? self.rules,
            stateSetupFunctions: stateSetupFunctions ?? self.stateSetupFunctions,
            frameWidth: frameWidth ?? self.frameWidth,
            frameHeight: frameHeight ?? self.frameHeight
        )
    }
}
