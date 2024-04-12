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
        updateSnakePositions()
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
                    with: SnakeEntityCreationContext(length: 3,
                                                     head: SnakeGridPosition(x: 10, y: 10),
                                                     facingDirection: .east,
                                                     grid: self.grid),
                    in: context.ecs)
                let snakeEntity2 = SnakeGameEntityCreator.createSnakeEntity(
                    with: SnakeEntityCreationContext(length: 1,
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

                SnakeGameEntityCreator.createJoystick(
                    center: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 7 / 8),
                    snakeEntity: snakeEntity1,
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

    private func updateSnakePositions() {
        blueprint = blueprint
            .forEachTick { _, context in
                let ecs = context.ecs

                let stopwatchEntities = ecs.getEntities(with: [StopWatchComponent.self])
                let snakeGameTickEntities = ecs.getEntities(with: [SnakeGameTick.self])

                guard !stopwatchEntities.isEmpty,
                      !snakeGameTickEntities.isEmpty,
                      let stopwatchComponent = ecs.getComponent(ofType: StopWatchComponent.self,
                                                                for: stopwatchEntities[0]),
                      let snakeGameTickComponent = ecs.getComponent(ofType: SnakeGameTick.self,
                                                                    for: snakeGameTickEntities[0]),
                      stopwatchComponent.currentTime.rounded() != snakeGameTickComponent.elapsed.rounded()
                else {
                    return
                }

                // Every second
                ecs.upsertComponent(SnakeGameTick(elapsed: stopwatchComponent.currentTime.rounded()),
                                    to: snakeGameTickEntities[0])

                let snakes = ecs.getEntities(with: [SnakeComponent.self])
                for snake in snakes {
                    guard let snakeComponent = ecs.getComponent(ofType: SnakeComponent.self, for: snake) else {
                        assertionFailure("Unable to get SnakeComponent on Snake entity")
                        continue
                    }
                    guard let head = snakeComponent.occupies.first,
                          let headBlockGridComponent = ecs.getComponent(ofType: SnakeGridPositionComponent.self, for: head) else {
                        assertionFailure("Unable to get head body block component of SnakeComponent")
                        continue
                    }

                    var copy = snakeComponent
                    let nextBlockGridPosition = headBlockGridComponent.gridPosition.applyDelta(snakeComponent.direction)
                    let nextBlock = SnakeGameEntityCreator.createBodyBlockEntity(at: nextBlockGridPosition,
                                                                                 with: self.grid,
                                                                                 in: ecs)
                    copy.occupies.prepend(nextBlock)

                    guard let last = copy.occupies.popLast() else {
                        assertionFailure("Snake tail not found!")
                        continue
                    }
                    ecs.removeEntity(last)
                    ecs.upsertComponent(copy, to: snake)
                }
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
                        BitmapImageRenderableComponent(imageResourcePath: SnakeGameImages.apple, width: Double(self.grid.boxSideLength), height: Double(self.grid.boxSideLength))
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
