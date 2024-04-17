import Foundation

typealias SnakeGameActionContext = ArkActionContext<SnakeGameExternalResources>

class SnakeGame {
    private(set) var blueprint: ArkBlueprint<SnakeGameExternalResources>
    private var playerIdToSnakeEntityMap = [Int: Entity]()
    private var snakeEntityToPlayerIdMap = [Entity: Int]()

    private static let gridHeight: Double = 800
    private static let gridWidth: Double = 800
    private var grid = SnakeGrid(boxSideLength: 20, gridHeight: gridHeight, gridWidth: gridWidth)

    private static let numApples: Int = 4

    init() {
        self.blueprint = ArkBlueprint(frameWidth: SnakeGame.gridWidth, frameHeight: SnakeGame.gridHeight)
        setup()
    }

    private func setup() {
        setupBackground()
        setupPlayer()
        setupSnakeGameTick()
        updateSnakePositions(
            initialTicksPerSecond: 1,
            getScalingFactor: { currentTime in
                let speedUpTwiceAfterXSeconds: Double = 15
                let scalingFactor = (currentTime / speedUpTwiceAfterXSeconds) + 1
                let maxScalingFactor: Double = 10
                return min(scalingFactor, maxScalingFactor)
            })
        appleSpawner()
        setupRules()
        setupWinLoseConditions()
    }
}

// MARK: Setup functions
extension SnakeGame {
    private func setupBackground() {
        blueprint = blueprint
            .setup { context in
                let ecs = context.ecs
                let display = context.display

                let canvasWidth = display.canvasSize.width
                let canvasHeight = display.canvasSize.height
                let canvasCenter = CGPoint(x: canvasWidth / 2, y: canvasHeight / 2)

                ecs.createEntity(with: [
                    BitmapImageRenderableComponent(arkImageResourcePath: SnakeGameImages.map,
                                                   width: canvasWidth, height: canvasHeight)
                    .center(canvasCenter)
                    .zPosition(0)
                    .layer(.canvas)
                ])
            }
    }

    private func setupPlayer() {
        blueprint = blueprint
            // Setup initial snake entity representation
            .setup { context in
                let snakeEntity1 = SnakeGameEntityCreator.createSnakeEntity(
                    with: SnakeEntityCreationContext(length: 10,
                                                     snakeId: 1,
                                                     head: SnakeGridPosition(x: 25, y: 25),
                                                     facingDirection: .north,
                                                     grid: self.grid),
                    in: context.ecs)
                let snakeEntity2 = SnakeGameEntityCreator.createSnakeEntity(
                    with: SnakeEntityCreationContext(length: 10,
                                                     snakeId: 2,
                                                     head: SnakeGridPosition(x: 15, y: 15),
                                                     facingDirection: .south,
                                                     grid: self.grid),
                    in: context.ecs)
                self.playerIdToSnakeEntityMap[1] = snakeEntity1
                self.playerIdToSnakeEntityMap[2] = snakeEntity2
                self.snakeEntityToPlayerIdMap[snakeEntity1] = 1
                self.snakeEntityToPlayerIdMap[snakeEntity2] = 2
                self.grid.snakeEntityToPlayerIdMap = self.snakeEntityToPlayerIdMap
            }
            // Setup player controls
            .setupPlayer { context in
                let display = context.display
                let screenWidth = display.screenSize.width
                let screenHeight = display.screenSize.height

                guard let snakeEntity1 = self.playerIdToSnakeEntityMap[1],
                      let snakeEntity2 = self.playerIdToSnakeEntityMap[2] else {
                    assertionFailure("Snake entity IDs do not yet exist when setting up DPad!")
                    return
                }

                SnakeGameEntityCreator.addDPad(
                    center: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 7 / 8),
                    snakeId: 1,
                    ecs: context.ecs,
                    events: context.events
                )
            }
            .setupPlayer { context in
                let display = context.display
                let screenWidth = display.screenSize.width
                let screenHeight = display.screenSize.height

                guard let snakeEntity1 = self.playerIdToSnakeEntityMap[1],
                      let snakeEntity2 = self.playerIdToSnakeEntityMap[2] else {
                    assertionFailure("Snake entity IDs do not yet exist when setting up DPad!")
                    return
                }
                SnakeGameEntityCreator.addDPad(
                    center: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 1 / 8),
                    snakeId: 2,
                    ecs: context.ecs,
                    events: context.events
                )
            }
    }

    private func setupSnakeGameTick() {
        blueprint = blueprint
            .setup { context in
                context.ecs.createEntity(with: [
                    SnakeGameTick(elapsed: 0)
                ])
            }
    }

    private func updateSnakePositions(initialTicksPerSecond: Double, getScalingFactor: @escaping (Double) -> Double) {
        blueprint = blueprint
            .forEachTick { timeContext, actionContext in
                // This time is for waiting before the game starts
                guard timeContext.clockTimeInSecondsGame > 5 else {
                    return
                }
                let ecs = actionContext.ecs
                let snakeGameTickEntities = ecs.getEntities(with: [SnakeGameTick.self])

                let getTickNumber: (Double) -> Double = { currentTime in
                    let speedScalingFactor = getScalingFactor(currentTime)
                    let ticksPerSecond: Double = initialTicksPerSecond * speedScalingFactor

                    return (currentTime * ticksPerSecond).rounded()
                }

                guard !snakeGameTickEntities.isEmpty,
                      let snakeGameTickComponent = ecs.getComponent(ofType: SnakeGameTick.self,
                                                                    for: snakeGameTickEntities[0]),
                      getTickNumber(timeContext.clockTimeInSecondsGame) != snakeGameTickComponent.elapsed
                else {
                    return
                }

                // Apply tick
                ecs.upsertComponent(SnakeGameTick(elapsed: getTickNumber(timeContext.clockTimeInSecondsGame)),
                                    to: snakeGameTickEntities[0])

                self.grid.tick(ecs: ecs)
            }
    }

    private func appleSpawner() {
        blueprint = blueprint
            .forEachTick { _, context in
                let ecs = context.ecs
                let appleEntities = ecs.getEntities(with: [SnakeGameApple.self])
                var count = appleEntities.count

                while count < SnakeGame.numApples {
                    let entitiesWithGridPosition = ecs.getEntities(with: [SnakeGridPositionComponent.self])
                    let gridPositionComponents = entitiesWithGridPosition
                        .compactMap { ecs.getComponent(ofType: SnakeGridPositionComponent.self, for: $0) }
                        .map { $0.gridPosition }
                    let emptyPosition = self.grid.getRandomEmptyBox(gridPositionComponents)

                    ecs.createEntity(with: [
                        SnakeGameApple(),
                        SnakeGridPositionComponent(gridPosition: emptyPosition),
                        PositionComponent(position: self.grid.toActualPosition(emptyPosition)),
                        BitmapImageRenderableComponent(arkImageResourcePath: SnakeGameImages.apple,
                                                       width: Double(self.grid.boxSideLength),
                                                       height: Double(self.grid.boxSideLength))
                            .layer(.canvas)
                            .zPosition(2)
                    ])

                    count += 1
                }
            }
    }

    private func setupWinLoseConditions() {
        blueprint = blueprint
            .forEachTick { timeContext, actionContext in
                let ecs = actionContext.ecs
                let snakes = ecs.getEntities(with: [SnakeComponent.self])

                if snakes.count <= 1 {
                    let eventData = TerminateGameLoopEventData(timeInGame: timeContext.clockTimeInSecondsGame)
                    actionContext.events.emit(TerminateGameLoopEvent(eventData: eventData))
                }
            }
    }

    private func setupRules() {
        blueprint = blueprint.on(SnakeChangeDirectionEvent.self) { event, context in
            self.handleChangeDirectionEvent(event, in: context)
        }
    }

    private func handleChangeDirectionEvent(_ event: SnakeChangeDirectionEvent, in context: SnakeGameActionContext) {
        let ecs = context.ecs
        let eventData = event.eventData
        guard let snakeEntity = self.playerIdToSnakeEntityMap[eventData.snakeId],
              let snakeComponent = ecs.getComponent(ofType: SnakeComponent.self, for: snakeEntity) else {
            return
        }

        let direction = eventData.direction

        if direction == snakeComponent.direction.opposite {
            return
        }

        let updatedSnakeComponent = SnakeComponent(snakeComponent.occupies, direction: direction)
        ecs.upsertComponent(updatedSnakeComponent, to: snakeEntity)
    }
}
