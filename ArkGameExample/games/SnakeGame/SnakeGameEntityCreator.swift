import Foundation

struct SnakeEntityCreationContext {
    let length: Int
    let snakeId: Int
    let head: SnakeGridPosition
    let facingDirection: SnakeGameDirection
    let grid: SnakeGrid
}

struct SnakeDPadCreationContext {
    let position: CGPoint
    let snakeId: Int
    let direction: SnakeGameDirection
}

struct SnakeGameEntityCreator {
    static func createSnakeEntity(with snakeCreationContext: SnakeEntityCreationContext,
                                  in ecsContext: ArkECSContext) -> Entity {
        let bodyDirection = snakeCreationContext.facingDirection.opposite
        let head = snakeCreationContext.head
        let grid = snakeCreationContext.grid
        let snakeId = snakeCreationContext.snakeId
        var occupiedSquares = SnakeGameDeque<Entity>()

        for i in 0..<snakeCreationContext.length {
            if i == 0 {
                let headBlock = createHeadBlockEntity(snakeId, at: head, with: grid, in: ecsContext)
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
            let nextBlock = createBodyBlockEntity(snakeId, at: nextGridPosition, with: grid, in: ecsContext)
            occupiedSquares.append(nextBlock)
        }

        let snakeEntity = ecsContext.createEntity(with: [
            SnakeComponent(occupiedSquares, direction: snakeCreationContext.facingDirection)
        ])

        return snakeEntity
    }

    static func createHeadBlockEntity(_ snakeId: Int,
                                      at gridPosition: SnakeGridPosition,
                                      with grid: SnakeGrid,
                                      in ecs: ArkECSContext) -> Entity {
        let headSize = Double(grid.boxSideLength) / 2 * 3
        let position = grid.toActualPosition(gridPosition)
        return ecs.createEntity(with: [
                    SnakeBodyBlock(),
                    SnakeGridPositionComponent(gridPosition: gridPosition),
                    PositionComponent(position: position),
                    BitmapImageRenderableComponent(arkImageResourcePath: SnakeGameImages.snakeHead(snakeId),
                                                   width: headSize, height: headSize)
                        .zPosition(1)
                        .layer(.canvas)
                        .center(position)
                        .userInteractionsEnabled(false)
                        .scaleAspectFill()
                ])
    }

    static func createBodyBlockEntity(_ snakeId: Int,
                                      at gridPosition: SnakeGridPosition,
                                      with grid: SnakeGrid,
                                      in ecs: ArkECSContext) -> Entity {
        let position = grid.toActualPosition(gridPosition)
        let bodySize = Double(grid.boxSideLength)

        return ecs.createEntity(with: [
                    SnakeBodyBlock(),
                    SnakeGridPositionComponent(gridPosition: gridPosition),
                    PositionComponent(position: position),
                    makeSnakeBodyRenderableComponent(snakeId, at: position, width: bodySize, height: bodySize)
                ])
    }

    static func makeSnakeBodyRenderableComponent(_ snakeId: Int,
                                                 at position: CGPoint,
                                                 width: Double,
                                                 height: Double) -> BitmapImageRenderableComponent {
        BitmapImageRenderableComponent(arkImageResourcePath: SnakeGameImages.snakeBody(snakeId),
                                       width: width, height: height)
                    .zPosition(1)
                    .layer(.canvas)
                    .center(position)
                    .userInteractionsEnabled(false)
                    .scaleAspectFill()
    }

    static func addDPad(center: CGPoint,
                        snakeId: Int,
                        ecs: ArkECSContext,
                        events: ArkEventContext) {
            let upButtonCreationContext
                    = SnakeDPadCreationContext(position: center.applying(CGAffineTransform(translationX: 0, y: -50)),
                                               snakeId: snakeId,
                                               direction: .north)
            let downButtonCreationContext
                    = SnakeDPadCreationContext(position: center.applying(CGAffineTransform(translationX: 0, y: 50)),
                                               snakeId: snakeId,
                                               direction: .south)
            let leftButtonCreationContext
                    = SnakeDPadCreationContext(position: center.applying(CGAffineTransform(translationX: -50, y: 0)),
                                               snakeId: snakeId,
                                               direction: .west)
            let rightButtonCreationContext
                    = SnakeDPadCreationContext(position: center.applying(CGAffineTransform(translationX: 50, y: 0)),
                                               snakeId: snakeId,
                                               direction: .east)
            addDPadButton(creationContext: upButtonCreationContext,
                          ecs: ecs,
                          events: events)
            addDPadButton(creationContext: downButtonCreationContext,
                          ecs: ecs,
                          events: events)
            addDPadButton(creationContext: leftButtonCreationContext,
                          ecs: ecs,
                          events: events)
            addDPadButton(creationContext: rightButtonCreationContext,
                          ecs: ecs,
                          events: events)
        }

    private static func addDPadButton(creationContext: SnakeDPadCreationContext,
                                      ecs: ArkECSContext,
                                      events: ArkEventContext) {
        let dPadEntity = ecs.createEntity()
        let direction = creationContext.direction
        let position = creationContext.position
        let snakeId = creationContext.snakeId
        let buttonComponent = ButtonRenderableComponent(width: 40, height: 40).label("<", color: .black)
            .shouldRerender {_, _ in
            false
            }
            .center(position)
            .rotation(direction.radians + CGFloat.pi / 2)
            .zPosition(999)
            .layer(.screen)
            .borderRadius(20)
            .borderColor(.white)
            .borderWidth(0.5)
            .background(color: .gray)
            .padding(top: 4, bottom: 4, left: 2, right: 2)
            .onTap {
                let changeDirectionEvent
                        = SnakeChangeDirectionEvent(eventData: SnakeChangeDirectionEventData(name: "",
                                                                                             snakeId: snakeId,
                                                                                             direction: direction))
                events.emit(changeDirectionEvent)
            }
        ecs.upsertComponent(buttonComponent, to: dPadEntity)
    }

    static func addJoystick(center: CGPoint, snakeEntity: Entity, in ecsContext: ArkECSContext) {
        let joystickComponent = JoystickRenderableComponent(radius: 40)
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

        ecsContext.upsertComponent(joystickComponent, to: snakeEntity)
    }
}
