public struct PauseGameLoopEventData: GameLoopEventData {
    public let timeInGame: Double
    public var name: String = "PauseGame"

    public init(timeInGame: Double) {
        self.timeInGame = timeInGame
    }
}

public struct PauseGameLoopEvent: ArkEvent {
    public var eventData: PauseGameLoopEventData
    public var priority: Int?

    public init(timeInGame: Double, priority: Int? = nil ) {
        self.eventData = PauseGameLoopEventData(timeInGame: timeInGame)
        self.priority = priority
    }
}
