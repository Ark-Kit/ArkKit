protocol CollisionHandlingStrategy<ActionContext> {
    associatedtype ActionContext: ArkActionContextProtocol

    func handleCollisionBegan(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ActionContext)

    func handleCollisionEnded(between entityA: Entity, and entityB: Entity,
                              bitMaskA: UInt32, bitMaskB: UInt32,
                              in context: ActionContext)
}
