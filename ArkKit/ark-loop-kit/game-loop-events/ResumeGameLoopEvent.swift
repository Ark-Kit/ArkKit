struct ResumeGameLoopEventData: GameLoopEventData {
    let timeInGame: Double
    var name: String = "ResumeGame"
}
struct ResumeGameLoopEvent: ArkEvent {
    var eventData: ResumeGameLoopEventData
    var priority: Int?
}
