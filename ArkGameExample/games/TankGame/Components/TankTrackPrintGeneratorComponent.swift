struct TankTrackPrintGeneratorComponent: Component {
    private static let initialDistance: Double = 40
    var distanceToNextPrint: Double = 0

    mutating func reset() {
        distanceToNextPrint += Self.initialDistance
    }
}
