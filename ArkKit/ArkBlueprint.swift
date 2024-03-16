struct ArkBlueprint {
    private(set) var rules: [Rule] = []
    mutating func rules<Event: ArkEvent>(on eventType: Event.Type,
                                         then action: Action) -> Self {
        rules.append(Rule(event: Event.id, action: action))
        return self
    }
}
