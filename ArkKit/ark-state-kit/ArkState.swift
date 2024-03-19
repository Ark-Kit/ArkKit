//
//  ArkState.swift
//  ArkKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

typealias ArkStateSetupFunction = (_: ArkECSContext, _: ArkEventContext) -> Void

class ArkState {
    private(set) var arkECS: ArkECS
    private(set) var eventManager: ArkEventManager

    init(eventManager: ArkEventManager, arkECS: ArkECS) {
        self.arkECS = arkECS
        self.eventManager = eventManager
    }

    func update(deltaTime: TimeInterval) {
        arkECS.update(deltaTime: deltaTime)
        eventManager.processEvents()
    }

    func setup(_ setupFunction: ArkStateSetupFunction) {
        setupFunction(arkECS, eventManager)
    }
}
