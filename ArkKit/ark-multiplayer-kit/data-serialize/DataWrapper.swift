import Foundation

enum PayloadType: String, Codable {
    case event, ecs
}

struct DataWrapper: Codable {
    let type: PayloadType
    let name: String
    let payload: Data
}
