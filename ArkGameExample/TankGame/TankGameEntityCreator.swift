import Foundation

struct TankCreationContext {
    let position: CGPoint
    let rotation: CGFloat
    let tankIndex: Int
    let zPosition: Double
    let hp: Double
}

struct TankBallCreationContext {
    let position: CGPoint
    let radius: CGFloat
    let velocity: CGVector
    let angle: CGFloat
    let zPosition: Double
}

struct TankShootButtonCreationContext {
    let position: CGPoint
    let tankId: Int
    let zPosition: Double
    let rotate: Bool
}

struct TankBackgroundCreationContext {
    let width: CGFloat
    let height: CGFloat
    let zPosition: Double
    let background: [[Int]]
}

enum TankGameEntityCreator {
    static func createHpBarComponent(hp: Double, zPosition: Double) -> any RenderableComponent {
        RectRenderableComponent(width: hp, height: 10)
            .modify(fillInfo: ShapeFillInfo(color: .red), strokeInfo: ShapeStrokeInfo(lineWidth: 3, color: .black))
            .zPosition(zPosition + 1)
            .layer(.canvas)
    }

    private static let tankIndexToImageAsset: [Int: TankGameImages] = [
        1: .tank_1,
        2: .tank_2,
        3: .tank_3,
        4: .tank_4
    ]

    @discardableResult
    static func createTank(with tankContext: TankCreationContext, in ecsContext: ArkECSContext) -> Entity {
        let position = tankContext.position
        let rotation = tankContext.rotation
        let zPosition = tankContext.zPosition
        let tankEntity = ecsContext.createEntity(with: [
            BitmapImageRenderableComponent(
                imageResourcePath: tankIndexToImageAsset[tankContext.tankIndex] ?? .tank_1,
                width: 80,
                height: 100
            )
            .center(position)
            .rotation(rotation)
            .zPosition(zPosition)
            .scaleAspectFill(),
            PositionComponent(position: position),
            RotationComponent(angleInRadians: rotation),
            PhysicsComponent(shape: .rectangle, size: CGSize(width: 80, height: 100),
                             isDynamic: false, allowsRotation: false, restitution: 0,
                             categoryBitMask: TankGamePhysicsCategory.tank,
                             collisionBitMask: TankGamePhysicsCategory.rock |
                             TankGamePhysicsCategory.wall |
                             TankGamePhysicsCategory.tank,
                             contactTestBitMask: TankGamePhysicsCategory.ball |
                             TankGamePhysicsCategory.tank |
                             TankGamePhysicsCategory.wall |
                             TankGamePhysicsCategory.water),
            createHpBarComponent(hp: tankContext.hp, zPosition: zPosition + 1),
            TankHpComponent(hp: tankContext.hp, maxHp: tankContext.hp)
        ])

        return tankEntity
    }

    @discardableResult
    static func createJoyStick(center: CGPoint,
                               tankId: Int,
                               in ecsContext: ArkECSContext,
                               eventContext: ArkEventContext,
                               zPosition: Double) -> Entity {
        ecsContext.createEntity(with: [
            JoystickRenderableComponent(radius: 40)
                .shouldRerender { old, new in
                    old.center != new.center
                }
                .center(center)
                .zPosition(zPosition)
                .layer(.screen)
                .onPanStart { angle, mag in
                    let tankMoveEventData = TankMoveEventData(name: "TankMoveEvent", tankId: tankId,
                                                              angle: angle, magnitude: mag)
                    let tankMoveEvent: any ArkEvent = TankMoveEvent(eventData: tankMoveEventData)
                    eventContext.emit(tankMoveEvent)
                }
                .onPanChange { angle, mag in
                    let tankMoveEventData = TankMoveEventData(name: "TankMoveEvent", tankId: tankId,
                                                              angle: angle, magnitude: mag)
                    let tankMoveEvent: any ArkEvent = TankMoveEvent(eventData: tankMoveEventData)
                    eventContext.emit(tankMoveEvent)
                }
                .onPanEnd { _, _ in
                    let tankMoveEventData = TankMoveEventData(name: "TankMoveEvent", tankId: tankId,
                                                              angle: 0, magnitude: 0)
                    let tankMoveEvent: any ArkEvent = TankMoveEvent(eventData: tankMoveEventData)
                    eventContext.emit(tankMoveEvent)
                }
        ])
    }

    static func createShootButton(with buttonContext: TankShootButtonCreationContext,
                                  in ecsContext: ArkECSContext,
                                  eventContext: ArkEventContext) -> Entity {
        ecsContext.createEntity(with: [
            ButtonRenderableComponent(width: 50, height: 50)
                .shouldRerender { old, new in
                    old.center != new.center
                }
                .center(buttonContext.position)
                .layer(.screen)
                .zPosition(buttonContext.zPosition)
                .onTap {
                    let tankShootEventData = TankShootEventData(name: "TankShootEvent", tankId: buttonContext.tankId)
                    let tankShootEvent: any ArkEvent = TankShootEvent(eventData: tankShootEventData)
                    eventContext.emit(tankShootEvent)
                }
                .label("Fire!", color: .blue)
                .borderRadius(20)
                .borderColor(.red)
                .borderWidth(0.5)
                .background(color: .green)
                .padding(top: 4, bottom: 4, left: 2, right: 2)
                .rotation(buttonContext.rotate ? .pi : 0)
        ])
    }

    static func createBall(with ballContext: TankBallCreationContext,
                           in ecsContext: ArkECSContext) {
        let radius = ballContext.radius
        ecsContext.createEntity(with: [
            BitmapImageRenderableComponent(
                imageResourcePath: TankGameImages.ball, width: radius * 2.2, height: radius * 2.2
            )
                .center(ballContext.position)
                .zPosition(ballContext.zPosition)
                .scaleAspectFill(),
            PositionComponent(position: ballContext.position),
            RotationComponent(angleInRadians: ballContext.angle),
            PhysicsComponent(shape: .circle,
                             radius: radius,
                             mass: 1,
                             velocity: ballContext.velocity,
                             isDynamic: true,
                             allowsRotation: true, restitution: 0.8,
                             categoryBitMask: TankGamePhysicsCategory.ball,
                             collisionBitMask: TankGamePhysicsCategory.wall |
                                            TankGamePhysicsCategory.rock,
                             contactTestBitMask: TankGamePhysicsCategory.ball | TankGamePhysicsCategory.wall |
                                            TankGamePhysicsCategory.rock | TankGamePhysicsCategory.tank)
        ])
    }

    static func createBoundaries(width: Double, height: Double, in ecsContext: ArkECSContext) {
        let halfWidth = width / 2
        let halfHeight = height / 2

        let thickness: Double = 20

        func createWallEntity(at position: CGPoint, size: CGSize) {
            ecsContext.createEntity(with: [
                PhysicsComponent(shape: .rectangle, size: size,
                                 isDynamic: false, allowsRotation: false, restitution: 0,
                                 categoryBitMask: TankGamePhysicsCategory.wall,
                                 collisionBitMask: TankGamePhysicsCategory.tank | TankGamePhysicsCategory.ball,
                                 contactTestBitMask: TankGamePhysicsCategory.tank | TankGamePhysicsCategory.ball),
                PositionComponent(position: position),
                RotationComponent(angleInRadians: 0)
            ])
        }
        // Top boundary
        createWallEntity(at: CGPoint(x: halfWidth, y: -thickness / 2),
                         size: CGSize(width: width, height: thickness))
        // Bottom boundary
        createWallEntity(at: CGPoint(x: halfWidth, y: height + thickness / 2),
                         size: CGSize(width: width, height: thickness))
        // Left boundary
        createWallEntity(at: CGPoint(x: -thickness / 2, y: halfHeight),
                         size: CGSize(width: thickness, height: height))
        // Right boundary
        createWallEntity(at: CGPoint(x: width + thickness / 2, y: halfHeight),
                         size: CGSize(width: thickness, height: height))
    }

    static func createBackground(with backgroundContext: TankBackgroundCreationContext,
                                 in ecsContext: ArkECSContext) {
        let mapBuilder = TankGameMapBuilder(width: backgroundContext.width,
                                            height: backgroundContext.height,
                                            ecsContext: ecsContext,
                                            zPosition: 0.0)
        mapBuilder.buildMap(from: backgroundContext.background)
    }

    static func createTerrainObjects(in ecsContext: ArkECSContext, objectsSpecs: [TankSpecification]) {
        let terrainObjectBuilder = TankGameTerrainObjectBuilder(ecsContext: ecsContext)

        terrainObjectBuilder.buildObjects(from: objectsSpecs)
    }
}
