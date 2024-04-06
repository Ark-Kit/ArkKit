/**
 * Devs should only use `ArkBlueprint` to defining the rules, events, and inputs.
 *
 * `ArkBlueprint` is effectively the blueprint struct that will be read to return an `Ark` game instance.
 */
struct ArkBlueprint<AudioEnum: ArkAudioEnum> {
    private(set) var rules: [any Rule] = []
    private(set) var setupFunctions: [ArkStateSetupDelegate] = []
    private(set) var soundMapping: [AudioEnum: any Sound]?

    // game world size
    private(set) var frameWidth: Double
    private(set) var frameHeight: Double

    func setup(_ fn: @escaping ArkStateSetupDelegate) -> Self {
        var stateSetupFunctionsCopy = setupFunctions
        stateSetupFunctionsCopy.append(fn)

        var newSelf = self
        newSelf.setupFunctions = stateSetupFunctionsCopy
        return newSelf
    }

    func withAudio(_ soundMapping: [AudioEnum: any Sound]) -> Self {
        guard self.soundMapping == nil else {
            assertionFailure("Audio has already been initialized!")
            return self
        }
        var newSelf = self
        newSelf.soundMapping = soundMapping
        return newSelf
    }

    /// Defines the event-based action to execute when the specified event occurs.
    func on<Event: ArkEvent>(
        _ eventType: Event.Type,
        executeIf conditions: (ArkECSContext) -> Bool...,
        then callback: @escaping ActionCallback<Event, AudioEnum>
    ) -> Self {
        let action = ArkEventAction(callback: callback)
        var newRules = rules
        let eventRule = ArkRule(trigger: RuleTrigger.event(eventType),
                                action: action,
                                conditions: conditions)
        newRules.append(eventRule)

        var newSelf = self
        newSelf.rules = newRules
        return newSelf
    }

    func on<Event: ArkEvent>(
        _ eventType: Event.Type,
        executeIf conditions: (ArkECSContext) -> Bool...,
        chain callbacks: ActionCallback<Event, AudioEnum>...
    ) -> Self {
        var newRules = rules
        for (i, callback) in callbacks.enumerated() {
            let action = ArkEventAction(callback: callback, priority: i + 1)

             let eventRule = ArkRule(trigger: RuleTrigger.event(eventType),
                                     action: action,
                                     conditions: conditions)
             newRules.append(eventRule)
        }
        var newSelf = self
        newSelf.rules = newRules
        return newSelf
    }

    func forEachTick(_ callback: @escaping UpdateActionCallback<AudioEnum>) -> Self {
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

/// Represents an ArkBlueprint without sounds added.
typealias ArkBlueprintWithoutSound = ArkBlueprint<NoSound>

enum NoSound: Int {
    case none
}
