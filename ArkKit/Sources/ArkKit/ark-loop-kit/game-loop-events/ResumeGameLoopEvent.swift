public struct ResumeGameLoopEventData: GameLoopEventData {
    public let timeInGame: Double
    public var name: String = "ResumeGame"

    public init(timeInGame: Double) {
        self.timeInGame = timeInGame
    }
}

public struct ResumeGameLoopEvent: ArkEvent {
    public var eventData: ResumeGameLoopEventData
    public var priority: Int?

    public init(timeInGame: Double, priority: Int? = nil) {
        self.eventData = ResumeGameLoopEventData(timeInGame: timeInGame)
        self.priority = priority
    }
}
