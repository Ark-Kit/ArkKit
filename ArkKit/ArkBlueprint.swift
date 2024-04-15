/**
 * Devs should only use `ArkBlueprint` to defining the rules, events, and inputs.
 *
 * `ArkBlueprint` is effectively the blueprint struct that will be read to return an `Ark` game instance.
 */
struct ArkBlueprint<ExternalResources: ArkExternalResources> {
    private(set) var rules: [any Rule] = []
    private(set) var setupFunctions: [ArkStateSetupDelegate] = []
    private(set) var soundMapping: [ExternalResources.AudioEnum: any Sound]?
    private(set) var networkPlayableInfo: ArkNetworkPlayableInfo?

    // if there is player specific setup
    private(set) var playerSpecificSetupFunctions: [ArkStateSetupDelegate] = []

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

    func withAudio(_ soundMapping: [ExternalResources.AudioEnum: any Sound]) -> Self {
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
        then callback: @escaping ActionCallback<Event, ExternalResources>
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
        chain callbacks: ActionCallback<Event, ExternalResources>...
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

    func forEachTick(_ callback: @escaping GameLoopActionCallback<ExternalResources>) -> Self {
        var newSelf = self
        var newRules = rules

        let action = ArkTickAction(callback: callback)
        let ruleForSystem = ArkRule(trigger: RuleTrigger.updateSystem, action: action)

        newRules.append(ruleForSystem)
        newSelf.rules = newRules
        return newSelf
    }

    func supportNetworkMultiPlayer(roomName: String, numberOfPlayers: Int) -> Self {
        var newSelf = self
        newSelf.networkPlayableInfo = ArkNetworkPlayableInfo(
            roomName: roomName, numberOfPlayers: numberOfPlayers
        )
        return newSelf
    }

    /// Only supports if Multiplayer is defined
    /// Note: maybe we can move this into a multiplayerContext so dev defines specific player controls
    func setupPlayer(_ fn: @escaping ArkStateSetupDelegate) -> Self {
        var playerStateSetupFunctionsCopy = playerSpecificSetupFunctions
        playerStateSetupFunctionsCopy.append(fn)

        var newSelf = self
        newSelf.playerSpecificSetupFunctions = playerStateSetupFunctionsCopy
        return newSelf
    }

    func setRole(_ role: ArkPeerRole) -> Self {
        var newSelf = self
        guard let originalNetworkInfo = self.networkPlayableInfo else {
            return newSelf
        }
        newSelf.networkPlayableInfo = ArkNetworkPlayableInfo(
            roomName: originalNetworkInfo.roomName,
            numberOfPlayers: originalNetworkInfo.numberOfPlayers,
            role: role
        )
        return newSelf
    }
}
