//
//  SystemManager.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

enum Schedule {
    case startup // only on first run
    case update
    case finish // finish systems to close when app is done
}

class SystemManager {
    typealias SystemType = ObjectIdentifier

    private(set) var scheduleToSystemMapping: [Schedule: OrderedDictionary<SystemType, System>] = [
        .startup: OrderedDictionary(),
        .update: OrderedDictionary(),
        .finish: OrderedDictionary()
    ]

    func add(_ system: System, schedule: Schedule = .update) {
        let identifier = ObjectIdentifier(type(of: system))
        scheduleToSystemMapping[schedule]?[identifier] = system
    }

    func remove<T: System>(ofType type: T.Type) {
        let identifier = ObjectIdentifier(type)
        for (schedule, _) in scheduleToSystemMapping {
            scheduleToSystemMapping[schedule]?.removeValue(forKey: identifier)
        }
    }

    func system<T: System>(ofType type: T.Type) -> T? {
        let identifier = ObjectIdentifier(type)
        for systemDict in scheduleToSystemMapping.values {
            if let system = systemDict[identifier] {
                return system as? T
            }
        }
        return nil
    }

    /// Runs the systems wihtin the `.update` schedule.
    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        guard let updateSystems = scheduleToSystemMapping[.update] else {
            return
        }
        for (_, system) in updateSystems {
            system.update(deltaTime: deltaTime, arkECS: arkECS)
        }
    }

}
