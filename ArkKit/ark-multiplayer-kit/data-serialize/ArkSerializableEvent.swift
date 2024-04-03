//
//  ArkSerializableEvent.swift
//  ArkKit
//
//  Created by Ryan Peh on 3/4/24.
//

protocol ArkSerializableEventData: ArkEventData, Codable {
}

protocol ArkSerializableEvent: ArkEvent, Codable where Data: ArkSerializableEventData {
}
