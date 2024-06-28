import Foundation
import ArkKit

struct TankShootEventData: ArkSerializableEventData {
    var name: String
    var tankId: Int
}

struct TankShootEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: TankShootEventData
    var priority: Int?

    init(eventData: TankShootEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
