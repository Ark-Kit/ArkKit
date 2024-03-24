import Foundation

enum TankGameEntityCreator {
    @discardableResult
    static func createTank(at position: CGPoint,
                           rotation: CGFloat,
                           tankIndex: Int,
                           in ecsContext: ArkECSContext,
                           zPosition: Double) -> Entity {
        let tankEntity = ecsContext.createEntity(with: [
            BitmapImageRenderableComponent(imageResourcePath: "tank_\(tankIndex)",
                                           width: 80,
                                           height: 100)
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
                             TankGamePhysicsCategory.water)
        ])
        return tankEntity
    }

    @discardableResult
    static func createJoyStick(center: CGPoint,
                               tankEntity: Entity,
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
                    let tankMoveEventData = TankMoveEventData(name: "TankMoveEvent", tankEntity: tankEntity,
                                                              angle: angle, magnitude: mag)
                    var tankMoveEvent: any ArkEvent = TankMoveEvent(eventData: tankMoveEventData)
                    eventContext.emit(&tankMoveEvent)
                }
                .onPanChange { angle, mag in
                    let tankMoveEventData = TankMoveEventData(name: "TankMoveEvent", tankEntity: tankEntity,
                                                              angle: angle, magnitude: mag)
                    var tankMoveEvent: any ArkEvent = TankMoveEvent(eventData: tankMoveEventData)
                    eventContext.emit(&tankMoveEvent)
                }
                .onPanEnd { _, _ in
                    let tankMoveEventData = TankMoveEventData(name: "TankMoveEvent", tankEntity: tankEntity,
                                                              angle: 0, magnitude: 0)
                    var tankMoveEvent: any ArkEvent = TankMoveEvent(eventData: tankMoveEventData)
                    eventContext.emit(&tankMoveEvent)
                }
        ])
    }

    static func createShootButton(at position: CGPoint, tankEntity: Entity, in ecsContext: ArkECSContext,
                                  eventContext: ArkEventContext, zPosition: Double) {
        ecsContext.createEntity(with: [
            ButtonRenderableComponent(width: 50, height: 50)
                .shouldRerender { _, _ in false }
                .center(position)
                .zPosition(zPosition)
                .onTap {
                    let tankShootEventData = TankShootEventData(name: "TankShootEvent", tankEntity: tankEntity)
                    var tankShootEvent: any ArkEvent = TankShootEvent(eventData: tankShootEventData)
                    eventContext.emit(&tankShootEvent)
                }
        ])
    }

    static func createBall(position: CGPoint, radius: CGFloat,
                           velocity: CGVector, angle: CGFloat,
                           in ecsContext: ArkECSContext, zPosition: Double) {
        ecsContext.createEntity(with: [
            BitmapImageRenderableComponent(imageResourcePath: "ball", width: radius * 2.2, height: radius * 2.2)
                .center(position)
                .zPosition(zPosition)
                .scaleAspectFill(),
            PositionComponent(position: position),
            RotationComponent(angleInRadians: angle),
            PhysicsComponent(shape: .circle,
                             radius: radius,
                             mass: 1,
                             velocity: velocity,
                             isDynamic: true,
                             allowsRotation: true, restitution: 0.8,
                             categoryBitMask: TankGamePhysicsCategory.ball,
                             collisionBitMask: TankGamePhysicsCategory.ball | TankGamePhysicsCategory.wall |
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

    static func createBackground(width: Double,
                                 height: Double,
                                 in ecsContext: ArkECSContext,
                                 zPosition: Double,
                                 background: [[Int]]) {
        let strategies: [TankGameTerrainStrategy] = [TankGameMap1Strategy(),
                                                     TankGameMap2Strategy(),
                                                     TankGameMap3Strategy()]
        let mapBuilder = TankGameMapBuilder(width: width, height: height,
                                            strategies: strategies,
                                            ecsContext: ecsContext,
                                            zPosition: 0.0)
        mapBuilder.buildMap(from: background)
    }

    static func createTerrainObjects(in ecsContext: ArkECSContext, objectsSpecs: [TankSpecification]) {
        let strategies: [TankGameTerrainObjectStrategy] = [TankGameLakeStrategy(), TankGameStoneStrategy()]
        let terrainObjectBuilder = TankGameTerrainObjectBuilder(strategies: strategies, ecsContext: ecsContext)

        terrainObjectBuilder.buildObjects(from: objectsSpecs)
    }
}
