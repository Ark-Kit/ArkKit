struct TankRaceEndPedalEvent: ArkSerializableEvent {
    var eventData: TankRacePedalEventData
    var priority: Int?

    init(eventData: TankRacePedalEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
