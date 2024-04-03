//
//  Entity.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

typealias EntityID = UUID

struct Entity {
    var id = EntityID()
}

extension Entity: Codable {
}

extension Entity: Hashable {
}
