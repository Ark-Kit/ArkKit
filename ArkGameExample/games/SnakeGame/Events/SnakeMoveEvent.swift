import Foundation

struct SnakeChangeDirectionEventData: ArkSerializableEventData {
    var name: String
    var snakeId: Int
    var direction: SnakeGameDirection
}

struct SnakeChangeDirectionEvent: ArkSerializableEvent {
    static var id = UUID()
    var eventData: SnakeChangeDirectionEventData
    var priority: Int?

    init(eventData: SnakeChangeDirectionEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
