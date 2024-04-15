import Foundation

typealias EntityID = UInt32

struct Entity {
    var id = EntityID()
}

extension Entity: Codable {
}

extension Entity: Hashable {
}
