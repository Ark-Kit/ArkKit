import Foundation

protocol TankRaceCollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>)

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>)
}

class TankRaceGameCollisionStrategyManager {
    private var strategies: [UInt32: [UInt32: TankRaceCollisionHandlingStrategy]] = [:]

    init() {
        register(strategy: TankRaceBallWallCollisionStrategy(),
                 for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.wall))
        register(strategy: TankRaceBallRockCollisionStrategy(),
                 for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.rock))
        register(strategy: TankFinishLineCollisionStrategy(),
                 for: (TankGamePhysicsCategory.tank, TankGamePhysicsCategory.water))
//        register(strategy: TankBallCollisionStrategy(),
//                 for: (TankGamePhysicsCategory.tank, TankGamePhysicsCategory.ball))
//        register(strategy: TankHealthPackCollisionStrategy(),
//                 for: (TankGamePhysicsCategory.tank, TankGamePhysicsCategory.healthPack))
    }

    private func register(strategy: TankRaceCollisionHandlingStrategy, for categories: (UInt32, UInt32)) {
        if strategies[categories.0] == nil {
            strategies[categories.0] = [:]
        }
        strategies[categories.0]?[categories.1] = strategy
    }

    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>) {
        if let strategy = strategies[bitMaskA]?[bitMaskB] {
            strategy.handleCollisionBegan(between: entityA, and: entityB,
                                          bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                          in: context)
        }
        if let strategy = strategies[bitMaskB]?[bitMaskA] {
            strategy.handleCollisionBegan(between: entityB, and: entityA,
                                          bitMaskA: bitMaskB, bitMaskB: bitMaskA,
                                          in: context)
        }
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>) {
        if let strategy = strategies[bitMaskA]?[bitMaskB] {
            strategy.handleCollisionEnded(between: entityA, and: entityB,
                                          bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                          in: context)
        }
        if let strategy = strategies[bitMaskB]?[bitMaskA] {
            strategy.handleCollisionEnded(between: entityB, and: entityA,
                                          bitMaskA: bitMaskB, bitMaskB: bitMaskA,
                                          in: context)
        }
    }
}

class TankRaceBallRockCollisionStrategy: TankRaceCollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>) {
        markBallForRemoval(entityA, in: context)
        let hpModifyEvent = TankHpModifyEvent(eventData:
                                                TankHpModifyEventData(name: "", tankEntity: entityB, hpChange: -10))
        context.events.emit(hpModifyEvent)
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>) {}
}

class TankRaceBallWallCollisionStrategy: TankRaceCollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>) {
        markBallForRemoval(entityA, in: context)
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>) {}
}

class TankFinishLineCollisionStrategy: TankRaceCollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>) {
        let ecs = context.ecs
        if let positionComponent = ecs.getComponent(ofType: PositionComponent.self, for: entityB) {
            ImpactExplosionAnimation(perFrameDuration: 0.1, width: 256, height: 256)
                .create(in: ecs, at: positionComponent.position)
        }
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkActionContext<NoSound>) {}
}
