//
//  ArkMultiplayerEventManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import Foundation

class ArkMultiplayerEventManager: ArkEventContext {
    private var arkEventManager = ArkEventManager()
    private var arkMultiplayerManager: ArkMultiplayerManager

    init(arkMultiplayerManager: ArkMultiplayerManager) {
        self.arkMultiplayerManager = arkMultiplayerManager
        self.arkMultiplayerManager.multiplayerEventManager = self
    }

    func subscribe(to eventId: ArkEventID, _ listener: @escaping (any ArkEvent) -> Void) {
        arkEventManager.subscribe(to: eventId, listener)
    }

    func emit<Event: ArkEvent>(_ event: Event) {
        arkEventManager.emit(event)
    }

    func processEvents() {
        arkEventManager.processEvents()
    }
}
