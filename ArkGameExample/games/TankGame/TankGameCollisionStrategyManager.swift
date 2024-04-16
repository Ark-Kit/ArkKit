import Foundation

enum TankGamePhysicsCategory {
    static let none: UInt32 = 0
    static let tank: UInt32 = 0x1 << 0
    static let ball: UInt32 = 0x1 << 1
    static let water: UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
    static let rock: UInt32 = 0x1 << 4
    static let healthPack: UInt32 = 0x1 << 5
}

class TankGameCollisionStrategyManager: CollisionStrategyManager<TankGameActionContext> {
    override
    init() {
        super.init()

        register(strategy: BallWallCollisionStrategy(),
                 for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.wall))
        register(strategy: BallRockCollisionStrategy(),
                 for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.rock))
        register(strategy: TankWaterCollisionStrategy(),
                 for: (TankGamePhysicsCategory.tank, TankGamePhysicsCategory.water))
        register(strategy: TankBallCollisionStrategy(),
                 for: (TankGamePhysicsCategory.tank, TankGamePhysicsCategory.ball))
        register(strategy: TankHealthPackCollisionStrategy(),
                 for: (TankGamePhysicsCategory.tank, TankGamePhysicsCategory.healthPack))

    }
}

func markEntityForRemoval<ExternalResources: ArkExternalResources>(_ entity: Entity,
                                                                   in context: ArkActionContext<ExternalResources>) {
    context.ecs.upsertComponent(ToRemoveComponent(), to: entity)
}

func markBallForRemoval<ExternalResources: ArkExternalResources>(_ entity: Entity,
                                                                 in context: ArkActionContext<ExternalResources>) {
    markEntityForRemoval(entity, in: context)

    let ecs = context.ecs
    if let positionComponent = ecs.getComponent(ofType: PositionComponent.self, for: entity) {
        ImpactExplosionAnimation(perFrameDuration: 0.1)
            .create(in: ecs, at: positionComponent.position)
    }
}

class BallWallCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankGameActionContext) {
        markBallForRemoval(entityA, in: context)
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankGameActionContext) {}
}

class BallRockCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankGameActionContext) {
        markBallForRemoval(entityA, in: context)
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankGameActionContext) {}
}

class TankBallCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankGameActionContext) {
        markBallForRemoval(entityB, in: context)
        let hpModifyEvent = TankHpModifyEvent(eventData:
                                                TankHpModifyEventData(name: "", tankEntity: entityA, hpChange: -10))
        context.events.emit(hpModifyEvent)
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankGameActionContext) {}
}

class TankWaterCollisionStrategy: CollisionHandlingStrategy {
    private func adjustLinearDamping(for entity: Entity,
                                     to damping: CGFloat,
                                     in context: TankGameActionContext) {
        guard var physicsComponent = context.ecs.getComponent(ofType: PhysicsComponent.self, for: entity) else {
            return
        }
        physicsComponent.linearDamping = damping
        context.ecs.upsertComponent(physicsComponent, to: entity)
    }

    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankGameActionContext) {
        adjustLinearDamping(for: entityA, to: 0.7, in: context)
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: TankGameActionContext) {
        adjustLinearDamping(for: entityA, to: 0.1, in: context)
    }
}

class TankHealthPackCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32, in context: TankGameActionContext) {
        markEntityForRemoval(entityB, in: context)
        let hpModifyEvent =
                TankHpModifyEvent(eventData: TankHpModifyEventData(name: "", tankEntity: entityA, hpChange: 20))
        context.events.emit(hpModifyEvent)
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity, bitMaskA: UInt32,
                              bitMaskB: UInt32, in context: TankGameActionContext) {
    }

}
