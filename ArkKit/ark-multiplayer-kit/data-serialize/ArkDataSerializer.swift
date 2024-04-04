//
//  ArkDataSerializer.swift
//  ArkKit
//
//  Created by Ryan Peh on 2/4/24.
//

import Foundation

class ArkDataSerializer {

    // Encode any ArkEvent into Data
    static func encodeEvent<Event: ArkEvent>(_ event: Event) throws -> Data? {
        guard let event = event as? any ArkSerializableEvent else {
            return nil
        }
        let eventData = try JSONEncoder().encode(event)
        let eventName = String(describing: type(of: event))
        let wrapper = DataWrapper(type: .event, name: eventName, payload: eventData)
        return try JSONEncoder().encode(wrapper)
    }

    // Decode Data into a specific ArkEvent
    static func decodeEvent(from data: Data, typeName: String, eventRegistry: ArkEventRegistry) throws -> any ArkEvent {
        let wrappedData = try JSONDecoder().decode(DataWrapper.self, from: data)
        guard wrappedData.type == .event, wrappedData.name == typeName else {
            throw NSError(domain: "ArkEventDataSerializer", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid event data or type"])
        }
        guard let event = try eventRegistry.decode(from: wrappedData.payload, typeName: typeName) else {
            throw NSError(domain: "ArkEventDataSerializer", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to decode event"])
        }
        return event
    }
}
