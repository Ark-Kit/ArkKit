//
//  DemoArkEvent.swift
//  ArkKit
//
//  Created by Ryan Peh on 13/3/24.
//

import Foundation

// The purpose of this file is to show all of you how to create events
// Comments helpfully written by GPT :>
// TODO: Remove this before submission

/// Represents the data associated with a DemoArkEvent.
struct DemoArkEventData: ArkEventData {
    var name: String
    var number: Int
}

/// Defines a demo event type with optional event data.
struct DemoArkEvent: ArkEvent {

    static var id = UUID()  // Unique identifier for the DemoArkEvent type.
    var eventData: ArkEventData?  // Optional event data.
    var priority: Int?

    /// Initializes a new DemoArkEvent with optional event data.
    /// - Parameter eventData: The data associated with the event, if any.
    init(eventData: ArkEventData? = nil, priority: Int? = nil) {
        self.eventData = eventData
        self.priority = priority
    }
}

/// Contains methods for testing event subscription and handling.
struct DemoArkEventTest {
    /// Subscribes to DemoArkEvent and handles it by printing event data.
    /// - Parameter em: The ArkEventManager instance used for managing events.
    static func testSubscribe(_ em: ArkEventManager) {
        em.subscribe(to: DemoArkEvent.id) { (event: ArkEvent) -> Void in
            // Cast the generic ArkEvent to a specific type to access its data.
            guard let eventData = event.eventData as? DemoArkEventData else {
                return
            }
            // Print event data for demonstration purposes.
            print(eventData.name)
            print(eventData.number)
        }
    }
}

// Usage example:
// 1. Initialize an instance of ArkEventManager.
// 2. Create a DemoArkEvent with specific event data.
// 3. Subscribe to the event and handle it.
// 4. Trigger the event emission.

// let em = ArkEventManager()
// let testEvent = DemoArkEvent(eventData: DemoArkEventData(name: "Hi", number: 4))
// DemoArkEventTest.testSubscribe(em)
// em.emit(DemoArkEvent.id)
