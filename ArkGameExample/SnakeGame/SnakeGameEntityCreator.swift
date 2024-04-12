import Foundation

struct SnakeEntityCreationContext {
    let length: Int
    let head: SnakeGridPosition
    let facingDirection: SnakeGameDirection
    let grid: SnakeGrid
}

struct SnakeGameEntityCreator {
    static func createSnakeEntity(with snakeCreationContext: SnakeEntityCreationContext,
                                  in ecsContext: ArkECSContext) -> Entity {
        guard let bodyDirection = snakeGameOppositeDirection[snakeCreationContext.facingDirection] else {
            assertionFailure("Snake opposite direction mapping missing values!")
            return Entity()
        }
        let head = snakeCreationContext.head
        let grid = snakeCreationContext.grid
        var occupiedSquares = SnakeGameDeque<Entity>()

        for i in 0..<snakeCreationContext.length {
            if i == 0 {
                let headBlock = createBodyBlockEntity(at: head, with: grid, in: ecsContext)
                occupiedSquares.append(headBlock)
                continue
            }

            guard let tail = occupiedSquares.last else {
                assertionFailure("Snake body does not exist!")
                break
            }
            guard let blockComponent = ecsContext.getComponent(ofType: SnakeBodyBlock.self, for: tail) else {
                assertionFailure("SnakeBodyBlock component does not exist!")
                break
            }

            let nextGridPosition = blockComponent.gridPosition.applyDelta(bodyDirection)
            let nextBlock = createBodyBlockEntity(at: nextGridPosition, with: grid, in: ecsContext)
            occupiedSquares.append(nextBlock)
        }

        let snakeEntity = ecsContext.createEntity(with: [
            SnakeComponent(occupiedSquares, direction: snakeCreationContext.facingDirection)
        ])

        return snakeEntity
    }

    static func createBodyBlockEntity(at gridPosition: SnakeGridPosition, with grid: SnakeGrid, in ecs: ArkECSContext) -> Entity {
        ecs.createEntity(with: [
            SnakeBodyBlock(gridPosition: gridPosition),
            PositionComponent(position: grid.toActualPosition(gridPosition)),
            RectRenderableComponent(width: grid.boxSideLength, height: grid.boxSideLength)
                .shouldRerender { _, _ in false }
                .zPosition(2)
                .layer(.canvas)
        ])
    }
}
