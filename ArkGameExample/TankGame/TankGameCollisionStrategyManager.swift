import Foundation

import Foundation

struct TankGamePhysicsCategory {
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
                              in context: ArkContext)
    
    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkContext)
}

class TankGameCollisionStrategyManager {
    private var strategies: [UInt32: [UInt32: CollisionHandlingStrategy]] = [:]

    init() {
        register(strategy: BallWallCollisionStrategy(), for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.wall))
        register(strategy: BallRockCollisionStrategy(), for: (TankGamePhysicsCategory.ball, TankGamePhysicsCategory.rock))
    }
    
    private func register(strategy: CollisionHandlingStrategy, for categories: (UInt32, UInt32)) {
        if strategies[categories.0] == nil {
            strategies[categories.0] = [:]
        }
        strategies[categories.0]?[categories.1] = strategy
    }
    
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkContext) {
        if let strategy = strategies[bitMaskA]?[bitMaskB] ?? strategies[bitMaskB]?[bitMaskA] {
            strategy.handleCollisionBegan(between: entityA, and: entityB,
                                          bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                          in: context)
        }
    }
    
    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkContext) {
        if let strategy = strategies[bitMaskA]?[bitMaskB] ?? strategies[bitMaskB]?[bitMaskA] {
            strategy.handleCollisionEnded(between: entityA, and: entityB,
                                          bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                          in: context)
        }
    }
}

class BallWallCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkContext) {
        // set ball to be removed check by bitmask
        if bitMaskA == TankGamePhysicsCategory.ball {
            guard var physicsComponent = context.ecs.getComponent(ofType: PhysicsComponent.self, for: entityA) else {
                return
            }
            physicsComponent.toBeRemoved = true
            context.ecs.upsertComponent(physicsComponent, to: entityA)
        } else if bitMaskB == TankGamePhysicsCategory.ball {
            guard var physicsComponent = context.ecs.getComponent(ofType: PhysicsComponent.self, for: entityB) else {
                return
            }
            physicsComponent.toBeRemoved = true
            context.ecs.upsertComponent(physicsComponent, to: entityB)
        }
    }
    
    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkContext) {
        // Logic specific to when a ball collides with a wall ends
    }
}

class BallRockCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkContext) {
        // Logic specific to when a ball collides with a rock begins
    }
    
    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkContext) {
        // Logic specific to when a ball collides with a rock ends
    }
}

class TankBallCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                                  bitMaskA: UInt32, bitMaskB: UInt32,
                                  in context: ArkContext) {
            // TODO: Add animation here
            // TODO: Add some hp management here? no logic yet
        }
        
        func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                                  bitMaskA: UInt32, bitMaskB: UInt32,
                                  in context: ArkContext) {
            // Logic specific to when a tank collides with a ball ends
        }
}

class TankWaterCollisionStrategy: CollisionHandlingStrategy {
    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkContext) {
        // Logic specific to when a tank collides with water begins
    }
    
    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ArkContext) {
        // Logic specific to when a tank collides with water ends
    }
}
