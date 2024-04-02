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
    case startup
    case update
    case finish
}

class SystemManager {
    typealias SystemType = ObjectIdentifier

    private(set) var systems: OrderedDictionary<SystemType, [System]> = OrderedDictionary()

    func add(_ system: System) {
        let identifier = ObjectIdentifier(type(of: system))
        if systems[identifier] == nil {
            systems[identifier] = []
        }
        systems[identifier]?.append(system)
    }

    func remove<T: System>(ofType type: T.Type) {
        let identifier = ObjectIdentifier(type)
        systems.removeValue(forKey: identifier)
    }

    func system<T: System>(ofType type: T.Type) -> [T] {
        let identifier = ObjectIdentifier(type)
        return systems[identifier]?.compactMap({ system in  system as? T }) ?? []
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        for (_, systemsPerType) in systems {
            for system in systemsPerType {
                system.update(deltaTime: deltaTime, arkECS: arkECS)
            }
        }
    }

}
