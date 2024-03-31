import Foundation

struct ScreenResizeEventData: ArkEventData {
    var name: String
    let newSize: CGSize
}

struct ScreenResizeEvent: ArkEvent {
    var eventData: ScreenResizeEventData
    var priority: Int?
}
