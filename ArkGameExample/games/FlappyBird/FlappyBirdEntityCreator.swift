import Foundation

enum FlappyBirdEntityCreator {
    static let impulseValue = CGVector(dx: 0, dy: -100)
    private static let groundAndSkyWallHeight = 50.0
    private static let pipeGap = 200.0
    private static let pipeWidth = 40.0

    @discardableResult
    static func createCharacter(context: ArkSetupContext, characterId: Int) -> Entity {
        let ecs = context.ecs
        let display = context.display

        let canvasWidth = display.canvasSize.width
        let canvasHeight = display.canvasSize.height
        let characterStartingPosition = CGPoint(x: canvasWidth * 1 / 3, y: canvasHeight * 1 / 4)

        let radius: Double = 20

        return ecs.createEntity(with: [
            CircleRenderableComponent(radius: radius)
                .fill(color: .red)
                .zPosition(1)
                .layer(.canvas),
            PositionComponent(position: characterStartingPosition),
            RotationComponent(),
            PhysicsComponent(shape: .circle, radius: radius,
                             isDynamic: true, affectedByGravity: true,
                             linearDamping: 10,
                             impulse: impulseValue,
                             categoryBitMask: FlappyBirdPhysicsCategory.character,
                             collisionBitMask: FlappyBirdPhysicsCategory.wall | FlappyBirdPhysicsCategory.ceiling,
                             contactTestBitMask: FlappyBirdPhysicsCategory.wall | FlappyBirdPhysicsCategory.ceiling),
            FlappyBirdCharacterTag(characterId: characterId)
        ])
    }

    @discardableResult
    static func setupTappableArea(characterId: Int, context: ArkSetupContext) -> Entity {
        let screenHeight = context.display.screenSize.height
        let screenWidth = context.display.screenSize.width

        return context.ecs.createEntity(with: [
            ButtonRenderableComponent(width: 70, height: 70)
                .shouldRerender { old, new in old.center != new.center }
                .center(CGPoint(x: screenWidth * 3 / 12, y: screenHeight * 10 / 11))
                .zPosition(999)
                .onTap {
                    let flappyBirdTapEventData = FlappyBirdTapEventData(name: "FlappyBirdTapEvent", characterId: 1)
                    let flappyBirdTapEvent = FlappyBirdTapEvent(eventData: flappyBirdTapEventData)
                    context.events.emit(flappyBirdTapEvent)
                }
                .label("Fly!", color: .white)
                .background(color: .gray)
                .padding(top: 5, bottom: 5, left: 5, right: 5)
                .layer(.screen)
        ])
    }

    static func setupGroundAndSkyWalls(context: ArkSetupContext) {
        let canvasWidth = context.display.canvasSize.width
        let size = CGSize(width: canvasWidth, height: groundAndSkyWallHeight)
        let xCoordinate = canvasWidth / 2

        let topWallContext = CreateWallContext(size: size,
                                               xCoordinate: xCoordinate,
                                               position: .top,
                                               physicsType: FlappyBirdPhysicsCategory.ceiling)
        let bottomWallContext = CreateWallContext(size: size,
                                                  xCoordinate: xCoordinate,
                                                  position: .bottom)

        spawnWall(with: topWallContext, in: context.ecs, and: context.display)
        spawnWall(with: bottomWallContext, in: context.ecs, and: context.display)
    }

    static func spawnPairPipes(context: FlappyBirdActionContext) {
        let ecs = context.ecs
        let display = context.display

        let canvasWidth = display.canvasSize.width
        let canvasHeight = display.canvasSize.height
        let additionalPadding = 200.0

        // Calculate range for top of 'gap'
        let minPlaceableY = groundAndSkyWallHeight + additionalPadding
        let maxPlaceableY = canvasHeight - groundAndSkyWallHeight - pipeGap - additionalPadding
        let placeableYRange = minPlaceableY ... maxPlaceableY

        let topOfGapY = Double.random(in: placeableYRange)
        let xCoordinate = canvasWidth + pipeWidth / 2

        let topWallContext = CreateWallContext(size: CGSize(width: pipeWidth, height: topOfGapY),
                                               xCoordinate: xCoordinate,
                                               position: .top,
                                               isPipe: true)
        let bottomWallContext = CreateWallContext(size: CGSize(width: pipeWidth,
                                                               height: canvasHeight - topOfGapY - pipeGap),
                                                  xCoordinate: xCoordinate,
                                                  position: .bottom,
                                                  isPipe: true)

        spawnWall(with: topWallContext, in: ecs, and: display)
        spawnWall(with: bottomWallContext, in: ecs, and: display)
    }
}

// MARK: Helpers

extension FlappyBirdEntityCreator {
    private enum FlappyBirdWallPosition {
        case top, bottom
    }

    private struct CreateWallContext {
        let size: CGSize
        let xCoordinate: Double
        let position: FlappyBirdWallPosition
        let physicsType: UInt32
        let isPipe: Bool

        init(size: CGSize,
             xCoordinate: Double,
             position: FlappyBirdWallPosition,
             physicsType: UInt32 = FlappyBirdPhysicsCategory.wall,
             isPipe: Bool = false)
        {
            self.size = size
            self.xCoordinate = xCoordinate
            self.position = position
            self.physicsType = physicsType
            self.isPipe = isPipe
        }
    }

    private static func spawnWall(with createWallContext: CreateWallContext,
                                  in ecs: ArkECSContext,
                                  and display: DisplayContext)
    {
        let size = createWallContext.size
        let xCoordinate = createWallContext.xCoordinate
        let position = createWallContext.position
        let physicsType = createWallContext.physicsType
        let isPipe = createWallContext.isPipe
        let isDynamic = createWallContext.isPipe

        let positionPoint = position == .top
            ? CGPoint(x: xCoordinate, y: size.height / 2)
            : CGPoint(x: xCoordinate, y: display.canvasSize.height - size.height / 2)

        let wall = ecs.createEntity(with: [
            RectRenderableComponent(width: size.width, height: size.height)
                .fill(color: .white),
            PositionComponent(position: positionPoint),
            RotationComponent(),
            PhysicsComponent(shape: .rectangle, size: size,
                             velocity: isPipe ? CGVector(dx: -100, dy: 0) : .zero,
                             isDynamic: isDynamic,
                             categoryBitMask: physicsType,
                             collisionBitMask: FlappyBirdPhysicsCategory.character,
                             contactTestBitMask: FlappyBirdPhysicsCategory.character)
        ])

        if isPipe {
            ecs.upsertComponent(FlappyBirdPipeTag(), to: wall)
        }
    }
}
