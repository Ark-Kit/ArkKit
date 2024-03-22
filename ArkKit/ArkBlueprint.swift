/**
 * Devs should only use `ArkBlueprint` to defining the rules, events, and inputs.
 *
 * `ArkBlueprint` is effectively the blueprint struct that will be read to return an `Ark` game instance.
 */
struct ArkBlueprint {
    private(set) var rules: [Rule] = []
    private(set) var setupFunctions: [ArkStateSetupFunction] = []
    private(set) var audioHandlers: [AudioHandler] = []

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

    func audio<Event: ArkEvent, T: RawRepresentable<String>>(
        on eventType: Event.Type,
        play: T, numberOfLoops: Int
    ) -> Self {
        var newAudioHandlers = audioHandlers
        newAudioHandlers.append(PlayAudioHandler(event: Event.id, filename: play, numberOfLoops: numberOfLoops))

        var newSelf = self
        newSelf.audioHandlers = newAudioHandlers
        return newSelf
    }

    func audio<Event: ArkEvent, T: RawRepresentable<String>>(on eventType: Event.Type, stop: T) -> Self {
        var newAudioHandlers = audioHandlers
        newAudioHandlers.append(StopAudioHandler(event: Event.id, filename: stop))

        var newSelf = self
        newSelf.audioHandlers = newAudioHandlers
        return newSelf
    }
}
