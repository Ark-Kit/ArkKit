import Foundation

class SnakeGame {
    private(set) var blueprint: ArkBlueprint<SnakeGameExternalResources>
    private var playerIdToSnakeEntityMap = [Int: Entity]()

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
                    BitmapImageRenderableComponent(imageResourcePath: SnakeGameImages.map,
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
                                                     head: SnakeGridPosition(x: 10, y: 10),
                                                     facingDirection: .east,
                                                     grid: self.grid),
                    in: context.ecs)
                let snakeEntity2 = SnakeGameEntityCreator.createSnakeEntity(
                    with: SnakeEntityCreationContext(length: 10,
                                                     head: SnakeGridPosition(x: 20, y: 20),
                                                     facingDirection: .west,
                                                     grid: self.grid),
                    in: context.ecs)
                self.playerIdToSnakeEntityMap[1] = snakeEntity1
                self.playerIdToSnakeEntityMap[2] = snakeEntity2
            }
            // Setup player controls
            .setup { context in
                let display = context.display
                let screenWidth = display.screenSize.width
                let screenHeight = display.screenSize.height

                guard let snakeEntity1 = self.playerIdToSnakeEntityMap[1],
                      let snakeEntity2 = self.playerIdToSnakeEntityMap[2] else {
                    assertionFailure("Snake entity IDs do not yet exist when setting up joystick!")
                    return
                }

                SnakeGameEntityCreator.addJoystick(
                    center: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 7 / 8),
                    snakeEntity: snakeEntity1,
                    in: context.ecs)

                SnakeGameEntityCreator.addJoystick(
                    center: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 1 / 8),
                    snakeEntity: snakeEntity2,
                    in: context.ecs)
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
                        BitmapImageRenderableComponent(imageResourcePath: SnakeGameImages.apple,
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
            .forEachTick { _, _ in
            }
    }
}
