protocol GameLoop: AnyObject {
    var updatePhysicsSceneDelegate: ArkPhysicsSceneUpdateLoopDelegate? { get set }
    var updateGameWorldDelegate: ArkGameWorldUpdateLoopDelegate? { get set }
    func setUp()
    func update()
    func getDeltaTime() -> Double
    func shutDown()
    func pauseLoop()
    func resumeLoop()
}

protocol ArkGameWorldUpdateLoopDelegate: AnyObject {
    func update(for dt: Double)
}

protocol ArkPhysicsSceneUpdateLoopDelegate: AnyObject {
    func update(_ deltaTime: Double)
}
