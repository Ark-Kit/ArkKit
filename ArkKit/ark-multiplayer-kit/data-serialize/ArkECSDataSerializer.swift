import Foundation

struct ArkECSDataSerializer {
    static func encodeArkECS(ecs: ArkECS) throws -> Data {
        let encoder = JSONEncoder()
        let ecsWrapper = ArkECSWrapper(from: ecs)
        let encodedECSData = try encoder.encode(ecsWrapper)
        let wrappedData = DataWrapper(type: .ecs, name: "ArkECS", payload: encodedECSData)
        return try encoder.encode(wrappedData)
    }

    static func decodeArkECS(from data: Data) throws -> ArkECSWrapper {
        let decoder = JSONDecoder()
        let ecsWrapper = try decoder.decode(ArkECSWrapper.self, from: data)
        return ecsWrapper
    }
}
