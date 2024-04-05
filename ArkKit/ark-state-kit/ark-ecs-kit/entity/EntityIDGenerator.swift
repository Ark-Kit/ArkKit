//
//  EntityIDGenerator.swift
//  ArkKit
//
//  Created by Ryan Peh on 5/4/24.
//

import Foundation

class EntityIDGenerator {
    private var currentID = 0
    private var recycledIDs = Set<EntityID>()

    func generate() -> EntityID {
        if let recycledID = recycledIDs.popFirst() {
            return recycledID
        }
        
        let id = currentID
        currentID += 1
        return id
    }

    func recycle(_ id: EntityID) {
        recycledIDs.insert(id)
    }
}
