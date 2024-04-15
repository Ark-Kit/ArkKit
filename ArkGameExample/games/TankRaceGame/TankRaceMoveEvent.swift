import Foundation

struct TankRaceMoveEventData: ArkSerializableEventData {
    var name: String
    var tankId: Int
}

struct TankRaceMoveEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: TankRaceMoveEventData
    var priority: Int?

    init(eventData: TankRaceMoveEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
