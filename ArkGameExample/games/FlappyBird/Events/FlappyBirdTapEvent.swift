import Foundation

struct FlappyBirdTapEventData: ArkSerializableEventData {
    let name: String
    let characterId: Int
}

struct FlappyBirdTapEvent: ArkSerializableEvent {
    static let id = UUID()
    let eventData: FlappyBirdTapEventData
    var priority: Int?

    init(eventData: FlappyBirdTapEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
