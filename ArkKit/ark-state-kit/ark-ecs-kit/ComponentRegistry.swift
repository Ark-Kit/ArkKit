//
//  ComponentRegistry.swift
//  ArkKit
//
//  Created by Ryan Peh on 6/4/24.
//

import Foundation

class ComponentRegistry {
    static let shared = ComponentRegistry()

    private init() {

    }

    private var componentTypes: [String: (Data) throws -> any Component] = [:]

    // Registers an event type with its corresponding decoder
    func register<T: Component>(_ componentType: T.Type) {
        guard let componentType = componentType as? any SendableComponent.Type else {
            return
        }
        let typeName = String(describing: T.self)
        componentTypes[typeName] = { data in
            try JSONDecoder().decode(componentType, from: data)
        }
    }

    func decode(from data: Data, typeName: String) throws -> (any Component)? {
        guard let decoder = componentTypes[typeName] else {
            return nil
        }
        return try decoder(data)
    }

    private func setUpComponentTypes() {
        let componentTypes = subclasses(of: SendableComponent.self)
        for componentType in componentTypes {
            if let componentType = componentType as? any Component.Type {
                register(componentType)
            }
        }
    }

    private func subclasses<T>(of theClass: T) -> [T] {
        var count: UInt32 = 0, result: [T] = []
        let classList = objc_copyClassList(&count)!
        defer { free(UnsafeMutableRawPointer(classList)) }
        let classes = UnsafeBufferPointer(start: classList, count: Int(count))
        let classPtr = address(of: theClass)

        for someClass in classes {
            guard let someSuperClass = class_getSuperclass(someClass), address(of: someSuperClass) == classPtr else {
                continue
            }
            // swiftlint:disable force_cast
            result.append(someClass as! T)
            // swiftlint:enable force_cast
        }

        return result
    }

    private func address(of object: Any?) -> UnsafeMutableRawPointer {
        Unmanaged.passUnretained(object as AnyObject).toOpaque()
    }
}
