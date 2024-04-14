import Foundation

typealias TankRaceGameActionContext = ArkActionContext<TankRaceGameExternalResources>

class TankRaceGameCollisionStrategyManager: CollisionStrategyManager<TankRaceGameActionContext> {
    override
    init() {
        super.init()
        register(strategy: TankRaceBallWallCollisionStrategy(),
                 for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.wall))
        register(strategy: TankRaceBallRockCollisionStrategy(),
                 for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.rock))
        register(strategy: TankFinishLineCollisionStrategy(),
                 for: (TankGamePhysicsCategory.tank, TankGamePhysicsCategory.water))
    }
}

class TankRaceBallRockCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankRaceGameActionContext) {
        markBallForRemoval(entityA, in: context)
        let hpModifyEvent = TankHpModifyEvent(eventData:
                                                TankHpModifyEventData(name: "", tankEntity: entityB, hpChange: -10))
        context.events.emit(hpModifyEvent)
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankRaceGameActionContext) {}
}

class TankRaceBallWallCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankRaceGameActionContext) {
        markBallForRemoval(entityA, in: context)
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankRaceGameActionContext) {}
}

class TankFinishLineCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankRaceGameActionContext) {
        let ecs = context.ecs
        if let positionComponent = ecs.getComponent(ofType: PositionComponent.self, for: entityB) {
            ImpactExplosionAnimation(perFrameDuration: 0.1, width: 256, height: 256)
                .create(in: ecs, at: positionComponent.position)
        }
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankRaceGameActionContext) {}
}
