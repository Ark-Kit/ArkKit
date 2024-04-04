//
//  ArkEvent.swift
//  ArkKit
//
//  Created by Ryan Peh on 13/3/24.
//

import Foundation

typealias ArkEventTypeIdentifier = ObjectIdentifier

protocol ArkEvent<Data> {
    associatedtype Data = ArkEventData

    var eventData: Data { get }
    var priority: Int? { get set }
}
