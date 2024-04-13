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
        let bodyDirection = snakeCreationContext.facingDirection.opposite
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
            guard let gridPositionComponent = ecsContext.getComponent(ofType: SnakeGridPositionComponent.self,
                                                                      for: tail)
            else {
                assertionFailure("SnakeGridPositionComponent component does not exist on tail block entity!")
                break
            }

            let nextGridPosition = gridPositionComponent.gridPosition.applyDelta(bodyDirection)
            let nextBlock = createBodyBlockEntity(at: nextGridPosition, with: grid, in: ecsContext)
            occupiedSquares.append(nextBlock)
        }

        let snakeEntity = ecsContext.createEntity(with: [
            SnakeComponent(occupiedSquares, direction: snakeCreationContext.facingDirection)
        ])

        return snakeEntity
    }

    static func createBodyBlockEntity(at gridPosition: SnakeGridPosition,
                                      with grid: SnakeGrid,
                                      in ecs: ArkECSContext) -> Entity {
        ecs.createEntity(with: [
            SnakeBodyBlock(),
            SnakeGridPositionComponent(gridPosition: gridPosition),
            PositionComponent(position: grid.toActualPosition(gridPosition)),
            RectRenderableComponent(width: Double(grid.boxSideLength), height: Double(grid.boxSideLength))
                .shouldRerender { _, _ in false }
                .zPosition(1)
                .layer(.canvas)
        ])
    }

    @discardableResult
    static func createJoystick(center: CGPoint,
                               snakeEntity: Entity,
                               in ecsContext: ArkECSContext) -> Entity {
        ecsContext.createEntity(with: [
            JoystickRenderableComponent(radius: 40)
                .shouldRerender { old, new in
                    old.center != new.center
                }
                .center(center)
                .zPosition(999)
                .layer(.screen)
                .onPanChange { angle, _ in
                    guard let snakeComponent = ecsContext.getComponent(
                        ofType: SnakeComponent.self,
                        for: snakeEntity
                    ) else {
                        assertionFailure("Snake entity does not contain SnakeComponent!")
                        return
                    }

                    let direction = SnakeGameDirection.fromRadians(angle)

                    // Prevent snake from going back onto itself
                    if snakeComponent.direction.opposite == direction {
                        return
                    }

                    let updatedSnakeComponent = SnakeComponent(snakeComponent.occupies, direction: direction)
                    ecsContext.upsertComponent(updatedSnakeComponent, to: snakeEntity)
                }
        ])
    }
}
