//
//  Entity.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

typealias EntityID = UUID

struct Entity {
    let id: EntityID = UUID()
}

extension Entity: Hashable {
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
