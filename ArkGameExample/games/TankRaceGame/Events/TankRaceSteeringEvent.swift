struct TankRaceSteeringEventData: ArkSerializableEventData {
    var name: String
    var tankId: Int
    var angleInRadians: Double
}

struct TankRaceSteeringEvent: ArkSerializableEvent {
    var eventData: TankRaceSteeringEventData
    var priority: Int?

    init(eventData: TankRaceSteeringEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
