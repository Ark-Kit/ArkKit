import Foundation

struct TankDestroyedEventData: ArkSerializableEventData {
    var name: String
    var tankEntity: Entity
}

struct TankDestroyedEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: TankDestroyedEventData
    var priority: Int?

    init(eventData: TankDestroyedEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
