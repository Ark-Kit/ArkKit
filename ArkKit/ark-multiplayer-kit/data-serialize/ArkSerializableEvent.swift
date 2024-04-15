protocol ArkSerializableEventData: ArkEventData, Codable {
}

protocol ArkSerializableEvent: ArkEvent, Codable where Data: ArkSerializableEventData {
}
