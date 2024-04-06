//
//  ArkECSSerializer.swift
//  ArkKit
//
//  Created by Ryan Peh on 5/4/24.
//

import Foundation

struct ArkECSSerializer {
    
    typealias ECSActionClosure = (ECSFunctionComponentData, ArkECS) -> Void
    
    enum ECSFunctionType: String, Codable {
        case createEntity, removeEntity, upsertComponent
    }

    
    static func encodeECSFunction(action: String, entity: Entity, component: Component? = nil,
                           components: [Component]? = nil) throws -> Data? {
        let sendableComponent = component as? SendableComponent
        let sendableComponents: [SendableComponent]? = components?.compactMap { $0 as? SendableComponent }
        
        if (component != nil && sendableComponent == nil) ||
            (components != nil && sendableComponents?.count != components?.count) {
            return nil
        }
        
        let componentData = ECSFunctionComponentData(entity: entity, component: sendableComponent,
                                                     components: sendableComponents)
        let data = try JSONEncoder().encode(componentData)
        let wrappedData = DataWrapper(type: .ecsFunction, name: action, payload: data)
        
        return try JSONEncoder().encode(wrappedData)
    }
    
    static func decodeECSFunction(data: Data, ecs: ArkECS) throws {
        // TODO: Not working properly, type erasure happens
        let actionsDictionary: [ECSFunctionType: ECSActionClosure] = [
            .createEntity: { componentData, ecs in
                if let components = componentData.components {
                    ecs.createEntity(id: componentData.entity.id, with: components)
                } else {
                    ecs.createEntity(id: componentData.entity.id)
                }
            },
            .removeEntity: { componentData, ecs in
                ecs.removeEntity(componentData.entity)
            },
            .upsertComponent: { componentData, ecs in
                if let component = componentData.component {
                    ecs.upsertComponent(component, to: componentData.entity)
                }
            }
        ]
        
        let decoder = JSONDecoder()
        let wrappedData = try decoder.decode(DataWrapper.self, from: data)

        let componentData = try decoder.decode(ECSFunctionComponentData.self, from: wrappedData.payload)
        if let functionType = ECSFunctionType(rawValue: wrappedData.name),
           let actionClosure = actionsDictionary[functionType] {
            actionClosure(componentData, ecs)
        } else {
            print("Unsupported action: \(wrappedData.name)")
        }
    }

    struct ECSFunctionComponentData: Codable {
        var entity: Entity
        var component: SendableComponent?
        var components: [SendableComponent]?
    }

    
    
}

