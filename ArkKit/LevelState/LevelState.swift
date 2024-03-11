//
//  LevelState.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

class LevelState {
    private let entityManager: EntityManager
    private let systemManager: SystemManager

    init() {
        self.entityManager = EntityManager()
        self.systemManager = SystemManager()
    }

}
