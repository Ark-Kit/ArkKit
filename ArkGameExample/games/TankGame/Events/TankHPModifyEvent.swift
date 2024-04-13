import Foundation

struct TankHpModifyEventData: ArkSerializableEventData {
    var name: String
    var tankEntity: Entity
    var hpChange: Double
}

struct TankHpModifyEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: TankHpModifyEventData
    var priority: Int?

    init(eventData: TankHpModifyEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
