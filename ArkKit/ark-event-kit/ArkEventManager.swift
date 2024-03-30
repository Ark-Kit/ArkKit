import Foundation

struct DatedEvent {
    let event: any ArkEvent
    let timestamp: Date
    var priority: Int?

    init(event: any ArkEvent, timestamp: Date = Date(), priority: Int? = nil) {
        self.event = event
        self.timestamp = timestamp
        self.priority = priority ?? event.priority
    }
}

class ArkEventManager: ArkEventContext {
    private var listeners: [ArkEventID: [(any ArkEvent) -> Void]] = [:]
    private var eventQueue = PriorityQueue<DatedEvent>(sort: ArkEventManager.compareEventPriority)

    func subscribe(to eventId: ArkEventID, _ listener: @escaping (any ArkEvent) -> Void) {
        if listeners[eventId] == nil {
            listeners[eventId] = []
        }

        listeners[eventId]?.append(listener)
    }

    func emit<Event: ArkEvent>(_ event: Event) {
        let datedEvent = DatedEvent(event: event)
        eventQueue.enqueue(datedEvent)
    }

    func processEvents() {
        while !eventQueue.isEmpty {
            guard let datedEvent = eventQueue.dequeue() else {
                fatalError("[ArkEventManager.processEvents()] dequeue failed: Expected event, found nil.")
            }
            guard let listenersToExecute = listeners[type(of: datedEvent.event).id] else {
                continue
            }
            listenersToExecute.forEach { listener in
                listener(datedEvent.event)
            }
        }
    }

    private static func compareEventPriority(datedEvent1: DatedEvent, datedEvent2: DatedEvent) -> Bool {
        let priority1 = datedEvent1.priority ?? 0
        let priority2 = datedEvent2.priority ?? 0

        if priority1 != priority2 {
            return priority1 > priority2
        }

        return datedEvent1.timestamp < datedEvent2.timestamp
    }
}
