//
//  TankMoveEvent.swift
//  ArkKit
//
//  Created by Ryan Peh on 21/3/24.
//

import Foundation

struct TankMoveEventData: ArkEventData {
    var name: String
    var tankEntity: Entity
    var angle: Double
    var magnitude: Double
}

struct TankMoveEvent: ArkEvent {
    static var id = UUID()
    var eventData: TankMoveEventData
    var timestamp = Date()
    var priority: Int?

    init(eventData: TankMoveEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
