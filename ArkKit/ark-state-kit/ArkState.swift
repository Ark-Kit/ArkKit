//
//  ArkState.swift
//  ArkKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

class ArkState {
    private let arkECS: ArkECS
    let eventManager: ArkEventManager


    init(eventManager: ArkEventManager = ArkEventManager()) {
        self.arkECS = ArkECS()
        self.eventManager = eventManager
    }
    
    func update(deltaTime: TimeInterval) {
        arkECS.update(deltaTime: deltaTime)
        eventManager.processEvents()
    }

}
