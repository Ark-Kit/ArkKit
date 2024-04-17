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
            BitmapImageRenderableComponent(imageResourcePath: FlappyBirdImage.characterMidflap.rawValue,
                                           width: radius * 2, height: radius * 2)
                .zPosition(1)
                .layer(.canvas)
                .shouldRerender { old, new in
                    old.rotation != new.rotation
                }
            ,
            PositionComponent(position: characterStartingPosition),
            RotationComponent(),
            PhysicsComponent(shape: .circle, radius: radius,
                             isDynamic: true, affectedByGravity: true,
                             linearDamping: 10,
                             impulse: impulseValue,
                             categoryBitMask: FlappyBirdPhysicsCategory.character,
                             collisionBitMask: FlappyBirdPhysicsCategory.ceiling,
                             contactTestBitMask: FlappyBirdPhysicsCategory.wall |
                                                 FlappyBirdPhysicsCategory.scoringArea),
            FlappyBirdCharacterTag(characterId: characterId)
        ])
    }

    static func initializeScore(context: ArkSetupContext, characterIds: [Int]) {
        let screenHeight = context.display.screenSize.height
        let screenWidth = context.display.screenSize.width

        var scoreComponent = FlappyBirdScore(scores: [:])

        for characterId in characterIds {
            scoreComponent.setScore(0, forId: characterId)
            context.ecs.createEntity(with: [
                RectRenderableComponent(width: 100, height: 56)
                    .center(CGPoint(x: screenWidth / 2, y: screenHeight * 1 / 11))
                    .label("0", color: .white, size: 56)
                    .fill(color: .transparent)
                    .zPosition(999)
                    .layer(.screen),
                FlappyBirdScoreLabelTag(characterId: characterId)
            ])
        }

        context.ecs.createEntity(with: [scoreComponent])

    }

    @discardableResult
    static func createBackground(context: ArkSetupContext) -> Entity {
        let ecs = context.ecs
        let display = context.display

        let canvasWidth = display.canvasSize.width
        let canvasHeight = display.canvasSize.height
        let canvasCenter = CGPoint(x: canvasWidth / 2, y: canvasHeight / 2)

        return ecs.createEntity(with: [
            BitmapImageRenderableComponent(imageResourcePath: FlappyBirdImage.background.rawValue,
                                           width: canvasWidth, height: canvasHeight)
            .center(canvasCenter)
            .zPosition(0)
            .layer(.canvas)
        ])
    }

    @discardableResult
    static func setupTappableArea(characterId: Int, context: ArkSetupContext) -> Entity {
        let screenHeight = context.display.screenSize.height
        let screenWidth = context.display.screenSize.width

        return context.ecs.createEntity(with: [
            RectRenderableComponent(width: screenWidth, height: screenHeight)
                .shouldRerender { old, new in old.center != new.center }
                .center(CGPoint(x: screenWidth / 2, y: screenHeight / 2))
                .fill(color: .transparent)
                .zPosition(999)
                .userInteractionsEnabled(true)
                .onTap {
                    let flappyBirdTapEventData = FlappyBirdTapEventData(name: "FlappyBirdTapEvent", characterId: 1)
                    let flappyBirdTapEvent = FlappyBirdTapEvent(eventData: flappyBirdTapEventData)
                    context.events.emit(flappyBirdTapEvent)
                }
                .layer(.screen)
        ])
    }

    @discardableResult
    static func spawnBase(context: ArkSetupContext) -> Entity {
        let canvasWidth = context.display.canvasSize.width
        let canvasHeight = context.display.canvasSize.height
        let size = CGSize(width: canvasWidth, height: groundAndSkyWallHeight)
        let xCoordinate = canvasWidth / 2
        let position = CGPoint(x: xCoordinate, y: canvasHeight - size.height / 2)

        return context.ecs.createEntity(with: [
            BitmapImageRenderableComponent(imageResourcePath: FlappyBirdImage.base.rawValue,
                                           width: size.width, height: size.height)
                .zPosition(3),
            PositionComponent(position: position),
            RotationComponent(),
            PhysicsComponent(shape: .rectangle, size: size,
                             isDynamic: false,
                             categoryBitMask: FlappyBirdPhysicsCategory.wall,
                             collisionBitMask: FlappyBirdPhysicsCategory.none,
                             contactTestBitMask: FlappyBirdPhysicsCategory.character)
        ])
    }

    @discardableResult
    static func spawnCeiling(context: ArkSetupContext) -> Entity {
        let canvasWidth = context.display.canvasSize.width
        let size = CGSize(width: canvasWidth, height: groundAndSkyWallHeight)
        let xCoordinate = canvasWidth / 2
        let position = CGPoint(x: xCoordinate, y: size.height / 2)

        return context.ecs.createEntity(with: [
            PositionComponent(position: position),
            RotationComponent(),
            PhysicsComponent(shape: .rectangle, size: size,
                             isDynamic: false,
                             categoryBitMask: FlappyBirdPhysicsCategory.ceiling,
                             collisionBitMask: FlappyBirdPhysicsCategory.character,
                             contactTestBitMask: FlappyBirdPhysicsCategory.character)

        ])
    }

    @discardableResult
    static func setGravity(context: ArkSetupContext) -> Entity {
        context.ecs.createEntity(with: [GravityComponent(gravityVector: CGVector(dx: 0, dy: 20))])
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
        let centerOfGapY = topOfGapY + pipeGap / 2
        let xCoordinate = canvasWidth + pipeWidth / 2

        let topPipeContext = CreatePipeContext(size: CGSize(width: pipeWidth, height: topOfGapY),
                                               xCoordinate: xCoordinate,
                                               position: .top)
        let bottomPipeContext = CreatePipeContext(size: CGSize(width: pipeWidth,
                                                               height: canvasHeight - topOfGapY - pipeGap),
                                                  xCoordinate: xCoordinate,
                                                  position: .bottom)
        let scoringAreaContext = CreateScoringAreaContext(size: CGSize(width: pipeWidth, height: pipeGap),
                                                          xCoordinate: xCoordinate, yCoordinate: centerOfGapY)

        spawnWall(with: topPipeContext, in: ecs, and: display)
        spawnWall(with: bottomPipeContext, in: ecs, and: display)
        spawnScoringArea(with: scoringAreaContext, in: ecs, and: display)
    }
}

// MARK: Helpers
extension FlappyBirdEntityCreator {
    public static let pipeVelocity = CGVector(dx: -100, dy: 0)

    private enum FlappyBirdWallPosition {
        case top, bottom
    }

    private struct CreatePipeContext {
        let size: CGSize
        let xCoordinate: Double
        let position: FlappyBirdWallPosition
    }

    private struct CreateScoringAreaContext {
        let size: CGSize
        let xCoordinate: Double
        let yCoordinate: Double
    }

    private static func spawnWall(with createPipeContext: CreatePipeContext,
                                  in ecs: ArkECSContext,
                                  and display: DisplayContext) {
        let size = createPipeContext.size
        let xCoordinate = createPipeContext.xCoordinate
        let position = createPipeContext.position

        let positionPoint = position == .top
            ? CGPoint(x: xCoordinate, y: size.height / 2)
            : CGPoint(x: xCoordinate, y: display.canvasSize.height - size.height / 2)

        let rotation = position == .top ? Double.pi : 0

        guard let gameSpeedEntity = ecs.getEntities(with: [FlappyBirdGameSpeed.self]).first else {
            return
        }

        guard let gameSpeed = ecs.getComponent(
            ofType: FlappyBirdGameSpeed.self, for: gameSpeedEntity) else {
            return
        }

        ecs.createEntity(with: [
            FlappyBirdPipeTag(),
            BitmapImageRenderableComponent(imageResourcePath: FlappyBirdImage.pipe.rawValue,
                                           width: size.width, height: size.height)
                .zPosition(2)
                .rotation(rotation)
                .center(positionPoint),
            PositionComponent(position: positionPoint),
            RotationComponent(angleInRadians: rotation),
            PhysicsComponent(shape: .rectangle, size: size,
                             velocity: gameSpeed.speed * pipeVelocity,
                             categoryBitMask: FlappyBirdPhysicsCategory.wall,
                             collisionBitMask: FlappyBirdPhysicsCategory.none,
                             contactTestBitMask: FlappyBirdPhysicsCategory.character)
        ])
    }

    private static func spawnScoringArea(with createScoringAreaContext: CreateScoringAreaContext,
                                         in ecs: ArkECSContext,
                                         and display: DisplayContext) {
        let size = createScoringAreaContext.size
        let xCoordinate = createScoringAreaContext.xCoordinate
        let yCoordinate = createScoringAreaContext.yCoordinate
        let positionPoint = CGPoint(x: xCoordinate, y: yCoordinate)

        guard let gameSpeedEntity = ecs.getEntities(with: [FlappyBirdGameSpeed.self]).first else {
            return
        }

        guard let gameSpeed = ecs.getComponent(
            ofType: FlappyBirdGameSpeed.self, for: gameSpeedEntity) else {
            return
        }

        ecs.createEntity(with: [
            FlappyBirdScoringAreaTag(),
            RectRenderableComponent(width: size.width, height: size.height)
                .fill(color: .transparent)
                .zPosition(3)
                .center(positionPoint),
            PositionComponent(position: positionPoint),
            RotationComponent(),
            PhysicsComponent(shape: .rectangle, size: size,
                             velocity: gameSpeed.speed * pipeVelocity,
                             categoryBitMask: FlappyBirdPhysicsCategory.scoringArea,
                             collisionBitMask: FlappyBirdPhysicsCategory.none,
                             contactTestBitMask: FlappyBirdPhysicsCategory.character)
        ])
    }
}
