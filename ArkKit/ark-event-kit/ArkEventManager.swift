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
    private var listeners: [ObjectIdentifier: [(any ArkEvent) -> Void]] = [:]
    private var eventQueue = PriorityQueue<DatedEvent>(sort: ArkEventManager.compareEventPriority)

    var networkPublisherDelegate: ArkNetworkPublisherDelegate?

    func subscribe<Event: ArkEvent>(to eventType: Event.Type, _ listener: @escaping (any ArkEvent) -> Void) {
        let typeID = ObjectIdentifier(eventType)
        if listeners[typeID] == nil {
            listeners[typeID] = []
            ArkEventRegistry.shared.register(eventType)
        }

        listeners[typeID]?.append(listener)
    }

    func emit<Event: ArkEvent>(_ event: Event) {
        let datedEvent = DatedEvent(event: event)
        eventQueue.enqueue(datedEvent)
        networkPublisherDelegate?.publish(event: event)
    }

    func emitWithoutDelegate<Event: ArkEvent>(_ event: Event) {
        let datedEvent = DatedEvent(event: event)
        eventQueue.enqueue(datedEvent)
    }

    func processEvents() {
        // copy eventQueue so that events emited during processing are processed at the next tick
        var eventsFromQueue = eventQueue
        while !eventsFromQueue.isEmpty {
            guard let datedEvent = eventsFromQueue.dequeue() else {
                fatalError("[ArkEventManager.processEvents()] dequeue failed: Expected event, found nil.")
            }
            // dequeue from copy and actual eventQueue so that they are in sync
            _ = eventQueue.dequeue()
            guard let listenersToExecute = listeners[ObjectIdentifier(type(of: datedEvent.event))] else {
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
