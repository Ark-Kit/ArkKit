//
//  ArkState.swift
//  ArkKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

class ArkState {
    private let arkECS: ArkECS
    var eventManager: ArkEventManager

    init(eventManager: ArkEventManager, arkECS: ArkECS) {
        self.arkECS = arkECS
        self.eventManager = eventManager
    }

    func update(deltaTime: TimeInterval) {
        arkECS.update(deltaTime: deltaTime)
        eventManager.processEvents()
    }
}
