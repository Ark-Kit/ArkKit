import Foundation

public struct ScreenResizeEventData: ArkEventData {
    public var name: String
    public let newSize: CGSize
}

public struct ScreenResizeEvent: ArkEvent {
    public var eventData: ScreenResizeEventData
    public var priority: Int?
}
