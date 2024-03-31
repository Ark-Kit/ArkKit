//
//  ArkEventRegistry.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import Foundation

class ArkEventRegistry {

    private var eventTypes: [String: (Data) throws -> any ArkEvent] = [:]

    func register<T: ArkEvent>(_ eventType: T.Type) {
        let typeName = String(describing: T.self)
        eventTypes[typeName] = { data in
            try JSONDecoder().decode(T.self, from: data)
        }
    }

    func decode(from data: Data, typeName: String) throws -> (any ArkEvent)? {
        guard let decoder = eventTypes[typeName] else {
            return nil
        }
        return try decoder(data)
    }
}
