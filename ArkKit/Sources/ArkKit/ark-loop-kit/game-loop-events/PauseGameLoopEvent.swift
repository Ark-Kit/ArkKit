struct PauseGameLoopEventData: GameLoopEventData {
    let timeInGame: Double
    var name: String = "PauseGame"
}
struct PauseGameLoopEvent: ArkEvent {
    var eventData: PauseGameLoopEventData
    var priority: Int?
}
