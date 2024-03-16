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
        print("start subsribe", listeners)
        if listeners[eventId] == nil {
            listeners[eventId] = []
        }
        self.listeners[eventId]?.append(listener)
        print("end subsribe", listeners)
    }

    func emit(_ event: inout ArkEvent) {
        event.timestamp = Date()
        eventQueue.enqueue(event)
    }

    func processEvents() {
        print("start processEvents", listeners)
        // If events generate more events, the new events will be processed in the next cycle
        var processingEventQueue = eventQueue
        eventQueue = PriorityQueue<ArkEvent>(sort: ArkEventManager.compareEventPriority)
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
            listeners[type(of: event).id] = Array(listeners[type(of: event).id]?
                .suffix(from: listenersToExecute.count) ?? [])

//            listeners[type(of: event).id]?.forEach { listener in
//                listener(event)
//            }

        }
        print("end processEvents", listeners)
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
