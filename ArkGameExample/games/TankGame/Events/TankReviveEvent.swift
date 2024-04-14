import Foundation

struct TankReviveEventData: ArkSerializableEventData {
    var name: String
    var tankEntity: Entity
}

struct TankReviveEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: TankReviveEventData
    var priority: Int?

    init(eventData: TankReviveEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
