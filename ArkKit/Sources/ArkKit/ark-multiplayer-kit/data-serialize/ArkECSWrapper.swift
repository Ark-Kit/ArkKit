import Foundation

struct ArkECSWrapper: Codable {
    var entities: [Entity]
    var components: [EntityID: [String: Data]]

    enum CodingKeys: String, CodingKey {
        case entities, components
    }

    init(from ecs: ArkECS) {
        self.entities = ecs.getEntities(with: [])
        self.components = entities.reduce(into: [EntityID: [String: Data]]()) { result, entity in
            let allComponents = ecs.getComponents(from: entity).compactMap { $0 as? Codable & Component }
            var componentData = [String: Data]()
            for component in allComponents {
                let typeName = String(describing: type(of: component))
                if let data = try? JSONEncoder().encode(component) {
                    componentData[typeName] = data
                }
            }
            result[entity.id] = componentData
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entities, forKey: .entities)
        try container.encode(components, forKey: .components)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entities = try container.decode([Entity].self, forKey: .entities)
        components = try container.decode([EntityID: [String: Data]].self, forKey: .components)
    }

    func decodeComponents() -> [EntityID: [any Component]] {
        var decodedComponents = [EntityID: [any Component]]()
        for (entityId, componentDict) in components {
            var entityComponents = [any Component]()
            for (typeName, data) in componentDict {
                if let component = try? ComponentRegistry.shared.decode(from: data, typeName: typeName) {
                    entityComponents.append(component)
                }
            }
            decodedComponents[entityId] = entityComponents
        }
        return decodedComponents
    }
}
