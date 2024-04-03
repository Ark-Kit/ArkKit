//
//  ArkEventRegistry.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import Foundation

class ArkEventRegistry {

    static let shared = ArkEventRegistry()

    private init() {}

    private var eventTypes: [String: (Data) throws -> any ArkEvent] = [:]

    // Registers an event type with its corresponding decoder
    func register<Event: ArkEvent>(_ eventType: Event.Type) {
        guard let eventType = eventType as? any ArkSerializableEvent.Type else {
            return
        }
        let typeName = String(describing: Event.self)
        eventTypes[typeName] = { data in
            try JSONDecoder().decode(eventType, from: data)
        }
    }

    // Decodes an event from Data using the registered decoder
    func decode(from data: Data, typeName: String) throws -> (any ArkEvent)? {
        guard let decoder = eventTypes[typeName] else {
            return nil
        }
        return try decoder(data)
    }
}
