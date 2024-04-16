import Foundation

struct FlappyBirdWallHitEventData: ArkSerializableEventData {
    let name: String
    let characterId: Int
}

struct FlappyBirdWallHitEvent: ArkSerializableEvent {
    static let id = UUID()
    let eventData: FlappyBirdWallHitEventData
    var priority: Int?

    init(eventData: FlappyBirdWallHitEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
