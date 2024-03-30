protocol GameLoopable {
    var gameLoop: GameLoop? { get set }
    func handleGameProgress(dt: Double)
}
