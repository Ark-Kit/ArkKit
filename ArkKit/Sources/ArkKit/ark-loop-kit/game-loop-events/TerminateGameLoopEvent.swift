public struct TerminateGameLoopEventData: GameLoopEventData {
    public let timeInGame: Double
    public var name: String = "TerminateGame"

    public init(timeInGame: Double) {
        self.timeInGame = timeInGame
    }
}

public struct TerminateGameLoopEvent: ArkEvent {
    public var eventData: TerminateGameLoopEventData
    public var priority: Int?

    public init(eventData: TerminateGameLoopEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
