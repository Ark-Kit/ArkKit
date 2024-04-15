import Foundation

class ArkPeerToPlayerIdSerializer {
    typealias PeerToPlayerIdMapping = [String: Int]

    static func encodeMapping(_ peerToIdMapping: PeerToPlayerIdMapping) throws -> Data {
        let encoder = JSONEncoder()
        let payload = try encoder.encode(peerToIdMapping)
        let wrappedData = DataWrapper(type: .playerMapping, name: "PeerToPlayerIdMapping", payload: payload)
        return try encoder.encode(wrappedData)
    }

    static func decodeMapping(from data: Data) throws -> PeerToPlayerIdMapping {
        let decoder = JSONDecoder()
        let mappingWrapper = try decoder.decode(PeerToPlayerIdMapping.self, from: data)
        return mappingWrapper
    }
}
