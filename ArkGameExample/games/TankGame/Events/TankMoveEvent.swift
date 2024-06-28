import Foundation
import ArkKit

struct TankMoveEventData: ArkSerializableEventData {
    var name: String
    var tankId: Int
    var angle: Double
    var magnitude: Double
}

struct TankMoveEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: TankMoveEventData
    var priority: Int?

    init(eventData: TankMoveEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
