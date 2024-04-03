//
//  ArkMultiplayerEventManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import Foundation

class ArkMultiplayerEventManager: ArkEventManagerDelegate {

    private var arkEventManager: ArkEventContext
    var networkManagerDelegate: ArkMultiplayerManagerDelegate?

    init(arkEventManager: ArkEventContext = ArkEventManager(),
         networkManagerDelegate: ArkMultiplayerManagerDelegate? = nil) {
        self.arkEventManager = arkEventManager
        self.networkManagerDelegate = networkManagerDelegate
    }

    func didEmitEvent<Event>(_ event: Event) where Event: ArkEvent {
        networkManagerDelegate?.shouldSendEvent(event)
    }

    func emitWithoutBroadcast<Event>(_ event: Event) where Event: ArkEvent {
        arkEventManager.emitWithoutDelegate(event)
    }
}

protocol ArkMultiplayerManagerDelegate: AnyObject {
    func shouldSendEvent<Event: ArkEvent>(_ event: Event)
}
