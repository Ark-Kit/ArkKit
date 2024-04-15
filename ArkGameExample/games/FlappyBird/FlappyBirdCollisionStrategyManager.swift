enum FlappyBirdPhysicsCategory {
    static let none: UInt32 = 0
    static let character: UInt32 = 0x1 << 0
    static let wall: UInt32 = 0x1 << 1
}

typealias FlappyBirdActionContext = ArkActionContext<FlappyBirdExternalResources>

class FlappyBirdCollisionStrategyManager: CollisionStrategyManager<FlappyBirdActionContext> {
    override
    init() {
        super.init()

        register(strategy: CharacterWallCollisionStrategy(), for: (FlappyBirdPhysicsCategory.character, FlappyBirdPhysicsCategory.wall))
    }
}

class CharacterWallCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: FlappyBirdActionContext) {}

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: FlappyBirdActionContext) {}
}
