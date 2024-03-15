//
//  ArkEvent.swift
//  ArkKit
//
//  Created by Ryan Peh on 13/3/24.
//

import Foundation

typealias ArkEventID = UUID

protocol ArkEvent {
    static var id: ArkEventID { get }
    var eventData: ArkEventData? { get }
    var timestamp: Date { get set }
    var priority: Int? { get set }
}
