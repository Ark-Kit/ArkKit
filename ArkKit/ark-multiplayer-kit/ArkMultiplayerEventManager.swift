//
//  ArkMultiplayerEventManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import Foundation

class ArkMultiplayerEventManager: ArkEventManager {
    private var arkEventManager: ArkEventManager
    var delegate: ArkMultiplayerEventManagerDelegate?

    init(arkEventManager: ArkEventManager = ArkEventManager(),
         delegate: ArkMultiplayerEventManagerDelegate? = nil) {
        self.arkEventManager = arkEventManager
        self.delegate = delegate
    }

    override func subscribe<Event: ArkEvent>(to eventType: Event.Type, _ listener: @escaping (any ArkEvent) -> Void) {
        arkEventManager.subscribe(to: eventType, listener)
    }

    override func emit<Event: ArkEvent>(_ event: Event) {
        if delegate?.isBroadcastEvent == true {
            delegate?.shouldSendEvent(event)
        }
        arkEventManager.emit(event)
    }

    func emitWithoutBroadcast<Event: ArkEvent>(_ event: Event) {
        arkEventManager.emit(event)
    }

    override func processEvents() {
        arkEventManager.processEvents()
    }
}

protocol ArkMultiplayerEventManagerDelegate: AnyObject {
    var isBroadcastEvent: Bool { get }
    func shouldSendEvent<Event: ArkEvent>(_ event: Event)
}
