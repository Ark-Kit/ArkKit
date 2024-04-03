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
        let action = ArkEventAction(callback: callback)
        var newRules = rules

         let eventRule = ArkRule(trigger: RuleTrigger.event(eventType),
                                 action: action)
         newRules.append(eventRule)

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
            let action = ArkEventAction(callback: callback, priority: i + 1)
             let eventRule = ArkRule(trigger: RuleTrigger.event(eventType),
                                     action: action)
             newRules.append(eventRule)
        }
        var newSelf = self
        newSelf.rules = newRules
        return newSelf
    }

    func forEachTick(_ callback: @escaping UpdateActionCallback) -> Self {
        var newSelf = self
        var newRules = rules

        let action = ArkTickAction(callback: callback)
        let ruleForSystem = ArkRule(trigger: RuleTrigger.updateSystem, action: action)

        newRules.append(ruleForSystem)
        newSelf.rules = newRules
        return newSelf
    }

    func setupMultiplayer(serviceName: String = "Ark") -> Self {
        let fn: ArkStateSetupDelegate = { context in
            var events = context.events

            let multiplayerManager = ArkMultiplayerManager(serviceName: serviceName)
            let multiplayerEventManager = ArkMultiplayerEventManager(arkEventManager: events,
                                                                     networkManagerDelegate: multiplayerManager)
            multiplayerManager.multiplayerEventManager = multiplayerEventManager

            events.delegate = multiplayerEventManager
        }

        var stateSetupFunctionsCopy = setupFunctions
        stateSetupFunctionsCopy.insert(fn, at: 0)

        var newSelf = self
        newSelf.setupFunctions = stateSetupFunctionsCopy
        return newSelf
    }
}
