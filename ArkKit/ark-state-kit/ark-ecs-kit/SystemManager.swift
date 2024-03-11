//
//  SystemManager.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

class SystemManager {
    private var systems: [ObjectIdentifier: System] = [:]

    func add(_ system: System) {
        let identifier = ObjectIdentifier(type(of: system))
        systems[identifier] = system
    }

    func remove<T: System>(ofType type: T.Type) {
        let identifier = ObjectIdentifier(type)
        systems.removeValue(forKey: identifier)
    }

    func system<T: System>(ofType type: T.Type) -> T? {
        let identifier = ObjectIdentifier(type)
        return systems[identifier] as? T
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        for system in systems.values {
            system.update(deltaTime: deltaTime, arkECS: arkECS)
        }
    }

}
