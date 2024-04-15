import Foundation

enum PayloadType: String, Codable {
    case event, ecs, playerMapping
}

struct DataWrapper: Codable {
    let type: PayloadType
    let name: String
    let payload: Data
}
