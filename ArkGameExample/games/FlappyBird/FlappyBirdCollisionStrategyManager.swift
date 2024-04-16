enum FlappyBirdPhysicsCategory {
    static let none: UInt32 = 0
    static let character: UInt32 = 0x1 << 0
    static let wall: UInt32 = 0x1 << 1
    static let ceiling: UInt32 = 0x1 << 2
    static let scoringArea: UInt32 = 0x1 << 3
}

typealias FlappyBirdActionContext = ArkActionContext<FlappyBirdExternalResources>

class FlappyBirdCollisionStrategyManager: CollisionStrategyManager<FlappyBirdActionContext> {
    override
    init() {
        super.init()

        register(strategy: CharacterWallCollisionStrategy(),
                 for: (FlappyBirdPhysicsCategory.character, FlappyBirdPhysicsCategory.wall))
        register(strategy: CharacterScoringAreaCollisionStrategy(),
                 for: (FlappyBirdPhysicsCategory.character, FlappyBirdPhysicsCategory.scoringArea))
    }
}

class CharacterWallCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: FlappyBirdActionContext) {
        let characterId = context.ecs.getComponent(ofType: FlappyBirdCharacterTag.self, for: entityA)?.characterId

        guard let characterId else {
            assertionFailure("CharacterWallCollisionStrategy: characterId is nil")
            return
        }

        context.events.emit(FlappyBirdWallHitEvent(eventData: FlappyBirdWallHitEventData(name: "FlappyBirdWallHit",
                                                                                         characterId: characterId)))
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: FlappyBirdActionContext) {}
}

class CharacterScoringAreaCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: FlappyBirdActionContext) {
        let characterId = context.ecs.getComponent(ofType: FlappyBirdCharacterTag.self, for: entityA)?.characterId

        guard let characterId else {
            assertionFailure("CharacterScoringAreaCollisionStrategy: characterId is nil")
            return
        }

        context.events.emit(FlappyBirdPipePassEvent(eventData: FlappyBirdPipePassEventData(name: "FlappyBirdPipePass",
                                                                                           characterId: characterId)))
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: FlappyBirdActionContext) {}
}
