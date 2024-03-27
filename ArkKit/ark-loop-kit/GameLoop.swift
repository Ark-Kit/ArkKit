protocol GameLoop {
    var updatePhysicsSceneDelegate: ArkPhysicsSceneUpdateLoopDelegate? { get set }
    var updateGameWorldDelegate: ArkGameWorldUpdateLoopDelegate? { get set }
    func setUp()
    func update()
    func getDeltaTime() -> Double
    func shutDown()
}

protocol ArkGameWorldUpdateLoopDelegate: AnyObject {
    func update(for dt: Double)
}

protocol ArkPhysicsSceneUpdateLoopDelegate: AnyObject {
    func update(_ deltaTime: Double)
}
