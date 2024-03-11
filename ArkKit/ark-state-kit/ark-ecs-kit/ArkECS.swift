//
//  ArkECS.swift
//  ArkKit
//
//  Created by Ryan Peh on 11/3/24.
//

import Foundation

class ArkECS {
    private let entityManager: EntityManager
    private let systemManager: SystemManager

    init() {
        self.entityManager = EntityManager()
        self.systemManager = SystemManager()
    }
    
    func update(deltaTime: TimeInterval) {
        systemManager.update(deltaTime: deltaTime, arkECS: self)
    }

}
