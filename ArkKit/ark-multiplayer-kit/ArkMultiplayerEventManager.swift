//
//  ArkMultiplayerEventManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import Foundation

class ArkMultiplayerEventManager: ArkEventManager {
    private var arkEventManager = ArkEventManager()
    weak var networkManagerDelegate: ArkMultiplayerManagerDelegate?

    init(networkManagerDelegate: ArkMultiplayerManagerDelegate? = nil) {
        self.networkManagerDelegate = networkManagerDelegate
        super.init()
        self.arkEventManager.eventRegistry = self.eventRegistry
    }

    override func subscribe<Event: ArkEvent>(to eventType: Event.Type, _ listener: @escaping (any ArkEvent) -> Void) {
        arkEventManager.subscribe(to: eventType, listener)
    }

    override func emit<Event: ArkEvent>(_ event: Event) {
        arkEventManager.emit(event)
        networkManagerDelegate?.shouldSendEvent(event)
    }

    func emitWithoutBroadcast<Event: ArkEvent>(_ event: Event) {
        arkEventManager.emit(event)
    }

    override func processEvents() {
        arkEventManager.processEvents()
    }
}

protocol ArkMultiplayerManagerDelegate: AnyObject {
    func shouldSendEvent<Event: ArkEvent>(_ event: Event)
}
