//
//  SystemManager.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

/**
 * `Schedule` represents the lifecycle of systems
 */
enum Schedule {
    case startUp
    case update
    case cleanUp
}

class SystemManager {
    typealias SystemType = ObjectIdentifier

    private(set) var systemsBySchedule: [Schedule: OrderedDictionary<SystemType, [System]>] = [
        .startUp: OrderedDictionary(),
        .update: OrderedDictionary(),
        .cleanUp: OrderedDictionary()
    ]

    private(set) var uniqueSystemsByType = Set<SystemType>()

    func add(_ system: System, schedule: Schedule = .update, isUnique: Bool = true) {
        let identifier = ObjectIdentifier(type(of: system))

        if isUnique {
            uniqueSystemsByType.insert(identifier)
        }

        if systemsBySchedule[schedule]?[identifier] == nil {
            systemsBySchedule[schedule]?[identifier] = []
        }

        let shouldNotAdd = uniqueSystemsByType.contains(identifier) &&
        (systemsBySchedule[schedule]?[identifier]?.count ?? 0) > 0

        if shouldNotAdd {
            return
        }
        systemsBySchedule[schedule]?[identifier]?.append(system)
    }

    func remove<T: System>(ofType type: T.Type) {
        let identifier = ObjectIdentifier(type)
        for schedule in systemsBySchedule.keys {
            systemsBySchedule[schedule]?.removeValue(forKey: identifier)
        }
    }

    func system<T: System>(ofType type: T.Type) -> [T] {
        let identifier = ObjectIdentifier(type)
        return systemsBySchedule.flatMap { _, systemsMapping in
            systemsMapping[identifier]?.compactMap({ system in system as? T }) ?? []
        }
    }

    func startUp() {
        guard let startupSystems = systemsBySchedule[.startUp] else {
            return
        }
        let runner = ArkSystemRunner()
        for (_, systemsPerType) in startupSystems {
            for system in systemsPerType {
                system.run(using: runner)
                system.active = false
            }
        }
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        guard let updateSystems = systemsBySchedule[.update] else {
            return
        }
        let runner = ArkSystemRunner(deltaTime: deltaTime, arkECS: arkECS)
        for (_, systemsPerType) in updateSystems {
            for system in systemsPerType {
                system.run(using: runner)
            }
        }
    }

    func cleanUp() {
        guard let cleanupSystems = systemsBySchedule[.cleanUp] else {
            return
        }
        let runner = ArkSystemRunner()
        for (_, systemsPerType) in cleanupSystems {
            for system in systemsPerType {
                system.run(using: runner)
            }
        }
    }

}
