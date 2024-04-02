//
//  ArkMultiplayerEventManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import Foundation

class ArkMultiplayerEventManager: ArkEventManager {
    private var arkEventManager = ArkEventManager()
    private var arkMultiplayerManager: ArkMultiplayerManager

    init(arkMultiplayerManager: ArkMultiplayerManager) {
        self.arkMultiplayerManager = arkMultiplayerManager
        super.init()

        self.arkMultiplayerManager.multiplayerEventManager = self
        self.arkEventManager.eventRegistry = self.eventRegistry
    }

    override func subscribe<Event: ArkEvent>(to eventType: Event.Type, _ listener: @escaping (any ArkEvent) -> Void) {
        arkEventManager.subscribe(to: eventType, listener)
    }

    override func emit<Event: ArkEvent>(_ event: Event) {
        arkEventManager.emit(event)
        arkMultiplayerManager.sendEvent(event: event)
    }

    func emitWithoutBroadcast<Event: ArkEvent>(_ event: Event) {
        arkEventManager.emit(event)
    }

    override func processEvents() {
        arkEventManager.processEvents()
    }
}
