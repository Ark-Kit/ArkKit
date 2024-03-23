import Foundation

struct TankGamePhysicsCategory {
    static let none: UInt32 = 0
    static let tank: UInt32 = 0x1 << 0
    static let ball: UInt32 = 0x1 << 1
    static let water: UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
    static let rock: UInt32 = 0x1 << 4
}
