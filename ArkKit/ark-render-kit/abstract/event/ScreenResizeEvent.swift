import Foundation

struct ScreenResizeEventData: ArkEventData {
    var name: String

    let newSize: CGSize
}

struct ScreenResizeEvent: ArkEvent {
    static var id = UUID()

    var eventData: ScreenResizeEventData
    var timestamp = Date()
    var priority: Int?
}
