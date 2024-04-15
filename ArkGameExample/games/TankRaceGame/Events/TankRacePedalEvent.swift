import Foundation

struct TankRacePedalEventData: ArkSerializableEventData {
    var name: String
    var tankId: Int
}

struct TankRacePedalEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: TankRacePedalEventData
    var priority: Int?

    init(eventData: TankRacePedalEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
