import Foundation

struct TankHealthPackGeneratorComponent: Component {
    static let initialTime: Double = 10
    let size: CGSize
    let zPosition: Double
    var id = UUID()
    var timeToNextHealthPack: Double = 0

    mutating func reset() {
        timeToNextHealthPack += Self.initialTime
    }
}
