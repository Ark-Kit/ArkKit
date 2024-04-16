import Foundation

struct FlappyBirdPipePassEventData: ArkSerializableEventData {
    let name: String
    let characterId: Int
}

struct FlappyBirdPipePassEvent: ArkSerializableEvent {
    static let id = UUID()
    let eventData: FlappyBirdPipePassEventData
    var priority: Int?

    init(eventData: FlappyBirdPipePassEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
