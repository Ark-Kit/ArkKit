struct TerminateGameLoopEventData: GameLoopEventData {
    let timeInGame: Double
    var name: String = "TerminateGame"
}
struct TerminateGameLoopEvent: ArkEvent {
    var eventData: TerminateGameLoopEventData
    var priority: Int?
}
