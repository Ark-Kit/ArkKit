import Foundation

struct TankHPModifyEventData: ArkSerializableEventData {
    var name: String
    var tankEntity: Entity
    var hpChange: Double
}

struct TankHPModifyEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: TankHPModifyEventData
    var priority: Int?

    init(eventData: TankHPModifyEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
