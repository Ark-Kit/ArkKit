class SnakeGameHelpers {
    let ecs: ArkECSContext

    init(ecs: ArkECSContext) {
        self.ecs = ecs
    }

    struct SnakeContext {
        let snake: Entity
        let snakeComponent: SnakeComponent
        let bodyPositions: [SnakeGridPosition]
    }

    func forEachSnake(_ callback: (_ snakeContext: SnakeContext) -> Void) {
        let snakes = ecs.getEntities(with: [SnakeComponent.self])
        for snake in snakes {
            guard let snakeComponent = ecs.getComponent(ofType: SnakeComponent.self, for: snake) else {
                assertionFailure("Cannot get SnakeComponent on Snake entity!")
                continue
            }

            let bodyPositions = snakeComponent.occupies.elements.compactMap { blockId in
                ecs.getComponent(ofType: SnakeGridPositionComponent.self, for: blockId)?.gridPosition
            }

            let snakeContext = SnakeContext(snake: snake,
                                            snakeComponent: snakeComponent,
                                            bodyPositions: bodyPositions)

            callback(snakeContext)
        }
    }
}
