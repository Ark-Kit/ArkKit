//
//  ArkMultiplayerEventManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import Foundation

class ArkMultiplayerEventManager: ArkEventManagerDelegate {
    private var arkEventManager: ArkEventContext
    var delegate: ArkMultiplayerEventManagerDelegate?

    init(arkEventManager: ArkEventContext = ArkEventManager(),
         delegate: ArkMultiplayerEventManagerDelegate? = nil) {
        self.arkEventManager = arkEventManager
        self.delegate = delegate
    }

    func didEmitEvent<Event>(_ event: Event) where Event: ArkEvent {
        delegate?.shouldSendEvent(event)
    }

    func emitWithoutBroadcast<Event>(_ event: Event) where Event: ArkEvent {
        arkEventManager.emitWithoutDelegate(event)
    }
}

protocol ArkMultiplayerEventManagerDelegate: AnyObject {
    func shouldSendEvent<Event: ArkEvent>(_ event: Event)
}
