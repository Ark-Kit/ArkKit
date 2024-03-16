//
//  ArkEventManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 13/3/24.
//

import Foundation

class ArkEventManager: ArkEventContext {
    private var listeners: [ArkEventID: [(ArkEvent) -> Void]] = [:]
    private var eventQueue = PriorityQueue<ArkEvent>(sort: ArkEventManager.compareEventPriority)

    func subscribe(to eventId: ArkEventID, listener: @escaping (ArkEvent) -> Void) {
        if listeners[eventId] == nil {
            listeners[eventId] = []
        }
        self.listeners[eventId]?.append(listener)
    }

    func emit(_ event: inout ArkEvent) {
        event.timestamp = Date()
        eventQueue.enqueue(event)
    }

    func processEvents() {
        // If events generate more events, the new events will be processed in the next cycle
        var processingEventQueue = eventQueue
        eventQueue = PriorityQueue<ArkEvent>(sort: ArkEventManager.compareEventPriority)
        while !processingEventQueue.isEmpty {
            guard let event = processingEventQueue.dequeue() else {
                fatalError("[ArkEventManager.processEvents()] dequeue failed: Expected event, found nil.")
            }
            listeners[type(of: event).id]?.forEach { listener in
                listener(event)
            }
            self.listeners[type(of: event).id] = []
        }
    }

    private static func compareEventPriority(event1: ArkEvent, event2: ArkEvent) -> Bool {
        let priority1 = event1.priority ?? 0
        let priority2 = event2.priority ?? 0

        if priority1 != priority2 {
            return priority1 > priority2
        }

        return event1.timestamp < event2.timestamp
    }

}
