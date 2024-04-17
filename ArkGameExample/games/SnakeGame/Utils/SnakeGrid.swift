import Foundation

struct SnakeGrid {
    let boxSideLength: Int
    let gridHeight: Double
    let gridWidth: Double
    var snakeEntityToPlayerIdMap: [Entity: Int]?

    var rows: Int {
        Int((gridHeight / Double(boxSideLength)).rounded(.down))
    }

    var cols: Int {
        Int((gridWidth / Double(boxSideLength)).rounded(.down))
    }

    func toActualPosition(_ gridPosition: SnakeGridPosition) -> CGPoint {
        let x = gridPosition.x * boxSideLength
        let y = gridPosition.y * boxSideLength

        return CGPoint(x: x, y: y)
    }

    func contains(_ gridPosition: SnakeGridPosition) -> Bool {
        gridPosition.x >= 0 && gridPosition.x < cols && gridPosition.y >= 0 && gridPosition.y < rows
    }

    func getRandomEmptyBox(_ occupiedGridPositions: [SnakeGridPosition]) -> SnakeGridPosition {
        let set = Set(occupiedGridPositions)
        let totalBoxes = rows * cols

        while set.count < totalBoxes {
            let row = Int.random(in: 0..<rows)
            let col = Int.random(in: 0..<cols)
            let gridPosition = SnakeGridPosition(x: row, y: col)
            if !set.contains(gridPosition) {
                return gridPosition
            }
        }

        return SnakeGridPosition(x: 0, y: 0)
    }
}

// MARK: Handle grid tick update
extension SnakeGrid {
    func tick(ecs: ArkECSContext) {
        updatePositions(ecs: ecs)
        handleBodyCutoff(ecs: ecs)
        handlePlayerSuicide(ecs: ecs)
        handleOutOfBounds(ecs: ecs)
    }

    /// Handles moving of snake body and eating of apples.
    private func updatePositions(ecs: ArkECSContext) {
        let apples = ecs.getEntities(with: [SnakeGameApple.self])
        let applePositionToEntityMapping: [SnakeGridPosition: Entity] = apples.reduce(into: [:]) { result, entity in
            guard let gridPosition = ecs.getComponent(ofType: SnakeGridPositionComponent.self, for: entity) else {
                assertionFailure("SnakeGridPositionComponent does not exist for apple!")
                return
            }
            result[gridPosition.gridPosition] = entity
        }

        SnakeGameHelpers(ecs: ecs).forEachSnake { context in
            let snake = context.snake
            let snakeComponent = context.snakeComponent
            guard let headPosition = context.bodyPositions.first else {
                return
            }

            // Always create the next head block
            var copy = snakeComponent
            let nextBlockPosition = headPosition.applyDelta(snakeComponent.direction)
            guard let snakeEntityToPlayerIdMap = snakeEntityToPlayerIdMap,
                  let snakeId = snakeEntityToPlayerIdMap[snake] else {
                return
            }
            let nextBlock = SnakeGameEntityCreator.createHeadBlockEntity(snakeId,
                                                                         at: nextBlockPosition,
                                                                         with: self,
                                                                         in: ecs)
            copy.occupies.prepend(nextBlock)

            // Update previous head renderable
            guard let currentHeadBlockId = snakeComponent.occupies.first else {
                return
            }

            guard let positionComponent = ecs.getComponent(ofType: PositionComponent.self, for: currentHeadBlockId) else {
                assertionFailure("PositionComponent does not exist for snake head!")
                return
            }

            let bodyBitMapComponent =
                    SnakeGameEntityCreator.makeSnakeBodyRenderableComponent(snakeId, at: positionComponent.position,
                                                                   width: Double(boxSideLength),
                                                                   height: Double(boxSideLength))
            ecs.removeComponent(ofType: BitmapImageRenderableComponent.self, from: currentHeadBlockId)
            ecs.upsertComponent(bodyBitMapComponent, to: currentHeadBlockId)

            // Account for presence of apple
            if let appleEntity = applePositionToEntityMapping[nextBlockPosition] {
                // Eat apple -> remove apple entity
                ecs.removeEntity(appleEntity)
            } else {
                // Else pop the tail block
                guard let last = copy.occupies.popLast() else {
                    assertionFailure("Snake tail not found!")
                    return
                }
                ecs.removeEntity(last)
            }
            ecs.upsertComponent(copy, to: snake)
        }
    }

    /// Handles case where a snake's body is 'eaten'/ 'cutoff' by another snake's head.
    /// The eaten snake's body should be truncated from the overlapping block to its tail.
    private func handleBodyCutoff(ecs: ArkECSContext) {
        // Gather all updates before applying them together
        var updates: [Entity: (SnakeComponent, [Entity])] = [:]
        let snakes = ecs.getEntities(with: [SnakeComponent.self])

        SnakeGameHelpers(ecs: ecs).forEachSnake { context in
            let snake = context.snake
            let snakeComponent = context.snakeComponent
            let ownBodyPositions = context.bodyPositions

            var copy = snakeComponent

            let otherSnakes = snakes.filter { s in s != snake }
            let otherSnakeHeadPositions = otherSnakes
                .compactMap { otherSnake in
                    ecs.getComponent(ofType: SnakeComponent.self, for: otherSnake)?.occupies.first
                }
                .compactMap { otherSnakeHead in
                    ecs.getComponent(ofType: SnakeGridPositionComponent.self, for: otherSnakeHead)?.gridPosition
                }

            var toBeRemoved: [Entity] = []
            for otherSnakeHeadPosition in otherSnakeHeadPositions
            where ownBodyPositions.contains(otherSnakeHeadPosition) {
                while true {
                    guard let lastBlockId = copy.occupies.last,
                          let lastBlockPosition = ecs.getComponent(ofType: SnakeGridPositionComponent.self,
                                                                   for: lastBlockId)?.gridPosition
                    else {
                        assertionFailure("Cannot get last block position on Snake entity!")
                        break
                    }

                    copy.occupies.popLast()
                    toBeRemoved.append(lastBlockId)

                    if lastBlockPosition == otherSnakeHeadPosition {
                        break
                    }
                }
            }
            updates[snake] = (copy, toBeRemoved)
        }

        // Apply updates
        for (snake, (snakeComponent, toBeRemoved)) in updates {
            ecs.upsertComponent(snakeComponent, to: snake)
            for item in toBeRemoved {
                ecs.removeEntity(item)
            }
        }
    }

    private func handlePlayerSuicide(ecs: ArkECSContext) {
        SnakeGameHelpers(ecs: ecs).forEachSnake { context in
            let snake = context.snake
            let snakeComponent = context.snakeComponent
            var bodyPositions = context.bodyPositions

            guard let headPosition = bodyPositions.first else {
                return
            }
            bodyPositions.remove(at: 0)

            guard bodyPositions.contains(headPosition) else {
                return
            }

            // Handle player suicide
            snakeComponent.occupies.elements.forEach { blockId in ecs.removeEntity(blockId) }
            ecs.removeEntity(snake)
        }
    }

    private func handleOutOfBounds(ecs: ArkECSContext) {
        SnakeGameHelpers(ecs: ecs).forEachSnake { context in
            let snake = context.snake
            let snakeComponent = context.snakeComponent
            let bodyPositions = context.bodyPositions
            guard let headPosition = bodyPositions.first else {
                return
            }

            guard !self.contains(headPosition) else {
                return
            }

            // Handle out of bounds
            snakeComponent.occupies.elements.forEach { blockId in ecs.removeEntity(blockId) }
            ecs.removeEntity(snake)
        }
    }
}
