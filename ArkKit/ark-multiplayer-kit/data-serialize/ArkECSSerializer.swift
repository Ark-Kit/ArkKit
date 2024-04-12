//
//  ArkECSSerializer.swift
//  ArkKit
//
//  Created by Ryan Peh on 5/4/24.
//

import Foundation

struct ArkECSSerializer {

    typealias ECSActionClosure = (Entity, [Component], ArkECS) -> Void

    enum ECSFunctionType: String, Codable {
        case createEntity, removeEntity, upsertComponent
    }

    static let actionsDictionary: [ECSFunctionType: ECSActionClosure] = [
        .createEntity: { entity, components, ecs in
            if components.isEmpty {
                ecs.createEntity(id: entity.id)
            } else {
                ecs.createEntity(id: entity.id, with: components)
            }
        },
        .removeEntity: { entity, _, ecs in
            ecs.removeEntity(entity)
        },
        .upsertComponent: { entity, components, ecs in
            if let component = components.first {
                ecs.upsertComponent(component, to: entity)
            }
        }
    ]

    private static func encodeComponent<T: Component>(_ component: T) throws -> ComponentData? {
        guard let component = component as? any SendableComponent else {
            return nil
        }
//        print("component is sendable component: \(component)")
        let componentData = try JSONEncoder().encode(component)
        let name = String(describing: type(of: component))

        return ComponentData(name: name, data: componentData)
    }

    static func encodeECSFunction(action: String, entity: Entity, component: Component? = nil,
                                  components: [Component]? = nil) throws -> Data? {

        var componentData = [ComponentData]()

        if let component = component,
           let encodedComponent = try encodeComponent(component) {
            componentData.append(encodedComponent)
        }

        componentData += components?.compactMap { try? encodeComponent($0) } ?? []

        let ecsfunctiondata = ECSFunctionData(entity: entity, componentData: componentData)
        let data = try JSONEncoder().encode(ecsfunctiondata)
        let wrappedData = DataWrapper(type: .ecsFunction, name: action, payload: data)

        return try JSONEncoder().encode(wrappedData)
    }

    static func decodeECSFunction(data: Data, name: String, ecs: ArkECS) throws {
        let decoder = JSONDecoder()
        let functionData = try decoder.decode(ECSFunctionData.self, from: data)

        let entity = functionData.entity
        let components = functionData.componentData
            .compactMap { try? ComponentRegistry.shared.decode(from: $0.data,
                                                               typeName: $0.name)
            }

        if let functionType = ECSFunctionType(rawValue: name),
           let actionClosure = actionsDictionary[functionType] {
            actionClosure(entity, components, ecs)
        } else {
            print("Unsupported action: \(functionData)")
        }
    }

    struct ComponentData: Codable {
        var name: String
        var data: Data
    }

    struct ECSFunctionData: Codable {
        var entity: Entity
        var componentData: [ComponentData]
    }

}
