//
//  ArkEvent.swift
//  ArkKit
//
//  Created by Ryan Peh on 13/3/24.
//

import Foundation

typealias ArkEventID = UUID

protocol ArkEvent<Data> {
    associatedtype Data = ArkEventData

    static var id: ArkEventID { get }
    var eventData: Data { get }
    var timestamp: Date { get set }
    var priority: Int? { get set }
}
