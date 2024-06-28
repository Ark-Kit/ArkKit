import Foundation

public typealias EntityID = UInt32

public struct Entity {
    public var id = EntityID()

    public init() {}

    public init(id: EntityID) {
        self.id = id
    }
}

extension Entity: Codable {
}

extension Entity: Hashable {
}
