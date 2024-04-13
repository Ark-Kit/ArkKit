/// Superclass for collision resolution. Extend this class and override the constructor with `register` calls to define
/// collision strategies for your custom CollisionStrategyManager.
class CollisionStrategyManager<ActionContext: ArkActionContextProtocol> {
    private var strategies: [UInt32: [UInt32: any CollisionHandlingStrategy<ActionContext>]] = [:]

    func register(strategy: any CollisionHandlingStrategy<ActionContext>, for categories: (UInt32, UInt32)) {
        if strategies[categories.0] == nil {
            strategies[categories.0] = [:]
        }
        strategies[categories.0]?[categories.1] = strategy
    }

    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ActionContext) {
        if let strategy = strategies[bitMaskA]?[bitMaskB] {
            strategy.handleCollisionBegan(between: entityA, and: entityB,
                                          bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                          in: context)
        } else if let strategy = strategies[bitMaskB]?[bitMaskA] {
            strategy.handleCollisionBegan(between: entityB, and: entityA,
                                          bitMaskA: bitMaskB, bitMaskB: bitMaskA,
                                          in: context)
        }
    }

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ActionContext) {
        if let strategy = strategies[bitMaskA]?[bitMaskB] {
            strategy.handleCollisionEnded(between: entityA, and: entityB,
                                          bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                          in: context)
        } else if let strategy = strategies[bitMaskB]?[bitMaskA] {
            strategy.handleCollisionEnded(between: entityB, and: entityA,
                                          bitMaskA: bitMaskB, bitMaskB: bitMaskA,
                                          in: context)
        }
    }
}
