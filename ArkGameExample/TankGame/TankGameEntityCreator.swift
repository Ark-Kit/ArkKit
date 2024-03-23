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
            // TODO: Set up physics
            PhysicsComponent(shape: .rectangle, size: CGSize(width: 80, height: 100), allowsRotation: true,
                             categoryBitMask: TankGamePhysicsCategory.tank,
                             collisionBitMask: TankGamePhysicsCategory.none,
                             contactTestBitMask: TankGamePhysicsCategory.ball | TankGamePhysicsCategory.wall | TankGamePhysicsCategory.water)
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

    static func createBall(position: CGPoint, velocity: CGVector, angle: CGFloat,
                           in ecsContext: ArkECSContext, zPosition: Double) {
        ecsContext.createEntity(with: [
            BitmapImageRenderableComponent(imageResourcePath: "ball", width: 20, height: 20)
                .center(position)
                .zPosition(zPosition)
                .scaleAspectFill(),
            PositionComponent(position: position),
            RotationComponent(angleInRadians: angle),
            // TODO: Set up physics
            PhysicsComponent(shape: .circle, radius: 20, velocity: velocity, allowsRotation: true,
                             categoryBitMask: TankGamePhysicsCategory.ball,
                             collisionBitMask: TankGamePhysicsCategory.ball,
                             contactTestBitMask: TankGamePhysicsCategory.tank | TankGamePhysicsCategory.wall)
        ])
    }

    static func createBackground(width: Double, height: Double, in ecsContext: ArkECSContext, zPosition: Double, background: [[Int]]) {
        let strategies: [TankGameTerrainStrategy] = [TankGameMap1Strategy(), TankGameMap2Strategy(), TankGameMap3Strategy()]
        let mapBuilder = TankGameMapBuilder(width: width, height: height, strategies: strategies, ecsContext: ecsContext, zPosition: 0.0)
        mapBuilder.buildMap(from: background)
    }

    static func createTerrainObjects(in ecsContext: ArkECSContext, objectsSpecs: [(type: Int, location: CGPoint, size: CGSize)]) {
        let strategies: [TankGameTerrainObjectStrategy] = [TankGameLakeStrategy(), TankGameStoneStrategy()]
        let terrainObjectBuilder = TankGameTerrainObjectBuilder(strategies: strategies, ecsContext: ecsContext)

        terrainObjectBuilder.buildObjects(from: objectsSpecs)
    }
}
