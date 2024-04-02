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
    func register<T: ArkEvent>(_ eventType: T.Type) {
        let typeName = String(describing: T.self)
        eventTypes[typeName] = { data in
            try JSONDecoder().decode(T.self, from: data)
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
