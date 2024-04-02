//
//  TankShootEvent.swift
//  ArkKit
//
//  Created by Ryan Peh on 21/3/24.
//

import Foundation

struct TankShootEventData: ArkEventData {
    var name: String
    var tankId: Int
}

struct TankShootEvent: ArkEvent {
    static var id = UUID()
    var eventData: TankShootEventData
    var priority: Int?

    init(eventData: TankShootEventData, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}
