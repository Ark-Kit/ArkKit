import Foundation

enum TankGamePhysicsCategory {
    static let none: UInt32 = 0
    static let tank: UInt32 = 0x1 << 0
    static let ball: UInt32 = 0x1 << 1
    static let water: UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
    static let rock: UInt32 = 0x1 << 4
}

protocol CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext)

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext)
}

class TankGameCollisionStrategyManager {
    private var strategies: [UInt32: [UInt32: CollisionHandlingStrategy]] = [:]

    init() {
        register(strategy: BallWallCollisionStrategy(),
                 for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.wall))
        register(strategy: BallRockCollisionStrategy(),
                 for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.rock))
        register(strategy: TankWaterCollisionStrategy(),
                 for: (TankGamePhysicsCategory.tank, TankGamePhysicsCategory.water))
        register(strategy: TankBallCollisionStrategy(),
                 for: (TankGamePhysicsCategory.tank, TankGamePhysicsCategory.ball))
    }

    private func register(strategy: CollisionHandlingStrategy, for categories: (UInt32, UInt32)) {
        if strategies[categories.0] == nil {
            strategies[categories.0] = [:]
        }
        strategies[categories.0]?[categories.1] = strategy
    }

    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {
        if let strategy = strategies[bitMaskA]?[bitMaskB] ?? strategies[bitMaskB]?[bitMaskA] {
            strategy.handleCollisionBegan(between: entityA, and: entityB,
                                          bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                          in: context)
        }
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {
        if let strategy = strategies[bitMaskA]?[bitMaskB] ?? strategies[bitMaskB]?[bitMaskA] {
            strategy.handleCollisionEnded(between: entityA, and: entityB,
                                          bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                          in: context)
        }
    }
}

func markEntityForRemoval(_ entity: Entity, in context: ArkActionContext) {
    guard var physicsComponent = context.ecs.getComponent(ofType: PhysicsComponent.self, for: entity) else {
        return
    }
    physicsComponent.toBeRemoved = true
    context.ecs.upsertComponent(physicsComponent, to: entity)
}

func markBallForRemoval(_ entity: Entity, in context: ArkActionContext) {
    markEntityForRemoval(entity, in: context)

    let ecs = context.ecs
    var positionComponent = ecs.getComponent(ofType: PositionComponent.self, for: entity)

    if let positionComponent {
        ImpactExplosionAnimation(perFrameDuration: 0.1)
            .create(in: ecs, at: positionComponent.position)
    }
}

class BallWallCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {
        if bitMaskA == TankGamePhysicsCategory.ball {
            markBallForRemoval(entityA, in: context)
        } else if bitMaskB == TankGamePhysicsCategory.ball {
            markBallForRemoval(entityB, in: context)
        }
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {}
}

class BallRockCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {
        if bitMaskA == TankGamePhysicsCategory.ball {
            markBallForRemoval(entityA, in: context)
        } else if bitMaskB == TankGamePhysicsCategory.ball {
            markBallForRemoval(entityB, in: context)
        }
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {}
}

class TankBallCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {
        if bitMaskA == TankGamePhysicsCategory.ball {
            markBallForRemoval(entityA, in: context)
        } else if bitMaskB == TankGamePhysicsCategory.ball {
            markBallForRemoval(entityB, in: context)
        }
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {}
}

class TankWaterCollisionStrategy: CollisionHandlingStrategy {
    private func adjustLinearDamping(for entity: Entity, to damping: CGFloat, in context: ArkActionContext) {
        guard var physicsComponent = context.ecs.getComponent(ofType: PhysicsComponent.self, for: entity) else {
            return
        }
        physicsComponent.linearDamping = damping
        context.ecs.upsertComponent(physicsComponent, to: entity)
    }

    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {
        if bitMaskA == TankGamePhysicsCategory.tank {
            adjustLinearDamping(for: entityA, to: 0.7, in: context)
        } else if bitMaskB == TankGamePhysicsCategory.ball {
            adjustLinearDamping(for: entityA, to: 0.7, in: context)
        }
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext) {
        if bitMaskA == TankGamePhysicsCategory.tank {
            adjustLinearDamping(for: entityA, to: 0.1, in: context)
        } else if bitMaskB == TankGamePhysicsCategory.ball {
            adjustLinearDamping(for: entityA, to: 0.1, in: context)
        }
    }
}
