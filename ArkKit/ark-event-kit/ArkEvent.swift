//
//  ArkEvent.swift
//  ArkKit
//
//  Created by Ryan Peh on 13/3/24.
//

import Foundation

typealias ArkEventID = String

protocol ArkEvent<Data>: Codable {
    associatedtype Data = ArkEventData

    static var id: String { get }
    var eventData: Data { get }
    var priority: Int? { get set }
}

extension ArkEvent {
    static var id: String {
        String(describing: self)
    }
}
