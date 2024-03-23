//
//  ArkEventManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 13/3/24.
//

import Foundation

class ArkEventManager: ArkEventContext {
    private var listeners: [ArkEventID: [(any ArkEvent) -> Void]] = [:]
    private var eventQueue = PriorityQueue<any ArkEvent>(sort: ArkEventManager.compareEventPriority)

    func subscribe(to eventId: ArkEventID, _ listener: @escaping (any ArkEvent) -> Void) {
        if listeners[eventId] == nil {
            listeners[eventId] = []
        }

        listeners[eventId]?.append(listener)
    }

    func emit<Event: ArkEvent>(_ event: inout Event) {
        event.timestamp = Date()
        eventQueue.enqueue(event)
    }

    func processEvents() {
        // If events generate more events, the new events will be processed in the next cycle
        var processingEventQueue = eventQueue
        eventQueue = PriorityQueue<any ArkEvent>(sort: ArkEventManager.compareEventPriority)
        while !processingEventQueue.isEmpty {
            guard let event = processingEventQueue.dequeue() else {
                fatalError("[ArkEventManager.processEvents()] dequeue failed: Expected event, found nil.")
            }
            guard let listenersToExecute = listeners[type(of: event).id] else {
                return
            }
            listenersToExecute.forEach { listener in
                listener(event)
            }
            // removes all listeners that have been executed
            listeners[type(of: event).id] = Array(listeners[type(of: event).id]?
                .suffix(from: listenersToExecute.count) ?? [])
        }
    }

    private static func compareEventPriority(event1: any ArkEvent, event2: any ArkEvent) -> Bool {
        let priority1 = event1.priority ?? 0
        let priority2 = event2.priority ?? 0

        if priority1 != priority2 {
            return priority1 > priority2
        }

        return event1.timestamp < event2.timestamp
    }

}
