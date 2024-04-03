//
//  DataWrapper.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import Foundation

enum PayloadType: String, Codable {
    case event, state
}

struct DataWrapper: Codable {
    let type: PayloadType
    let name: String
    let payload: Data
}
