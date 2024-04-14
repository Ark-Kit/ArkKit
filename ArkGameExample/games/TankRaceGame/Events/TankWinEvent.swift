import Foundation

struct TankWinEventData: ArkSerializableEventData {
    var name: String
    var tankId: Int
}

struct TankWinEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: TankWinEventData
    var priority: Int?

    init(eventData: TankWinEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
