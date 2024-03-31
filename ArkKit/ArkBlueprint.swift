/**
 * Devs should only use `ArkBlueprint` to defining the rules, events, and inputs.
 *
 * `ArkBlueprint` is effectively the blueprint struct that will be read to return an `Ark` game instance.
 */
struct ArkBlueprint {
    private(set) var rules: [any Rule] = []
    private(set) var setupFunctions: [ArkStateSetupDelegate] = []

    private(set) var frameWidth: Double
    private(set) var frameHeight: Double

    func setup(_ fn: @escaping ArkStateSetupDelegate) -> Self {
        var stateSetupFunctionsCopy = setupFunctions
        stateSetupFunctionsCopy.append(fn)

        var newSelf = self
        newSelf.setupFunctions = stateSetupFunctionsCopy
        return newSelf
    }

    func on<Event: ArkEvent>(
        _ eventType: Event.Type,
        then callback: @escaping ActionCallback<Event>
    ) -> Self {
        let action = ArkAction(callback: callback)
        var newRules = rules
        newRules.append(ArkRule(event: eventType, action: action))

        var newSelf = self
        newSelf.rules = newRules
        return newSelf
    }

    func on<Event: ArkEvent>(
        _ eventType: Event.Type,
        chain callbacks: ActionCallback<Event>...
    ) -> Self {
        var newRules = rules
        for (i, callback) in callbacks.enumerated() {
            let action = ArkAction(callback: callback, priority: i + 1)
            newRules.append(ArkRule(event: eventType, action: action))
        }
        var newSelf = self
        newSelf.rules = newRules
        return newSelf
    }
}
