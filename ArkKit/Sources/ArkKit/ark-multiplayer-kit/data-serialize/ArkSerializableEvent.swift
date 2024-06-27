public protocol ArkSerializableEventData: ArkEventData, Codable {
}

public protocol ArkSerializableEvent: ArkEvent, Codable where Data: ArkSerializableEventData {
}
