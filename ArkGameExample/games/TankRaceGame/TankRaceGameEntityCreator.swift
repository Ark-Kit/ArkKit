import Foundation

enum TankRaceGameEntityCreator {
    static func createHpBarComponent(hp: Double, zPosition: Double) -> any RenderableComponent {
        RectRenderableComponent(width: hp, height: 10)
            .modify(fillInfo: ShapeFillInfo(color: .red), strokeInfo: ShapeStrokeInfo(lineWidth: 3, color: .black))
            .zPosition(zPosition + 1)
            .layer(.canvas)
    }

    static func createMoveButton(position: CGPoint,
                                 tankId: Int,
                                 zPosition: Double,
                                 in ecsContext: ArkECSContext,
                                 eventContext: ArkEventContext) -> Entity {
        ecsContext.createEntity(with: [
            ButtonRenderableComponent(width: 70, height: 70)
                .shouldRerender { old, new in
                    old.center != new.center
                }
                .center(position)
                .layer(.screen)
                .zPosition(zPosition)
                .onTap {
                    let tankRaceMoveEventData = TankRaceMoveEventData(name: "TankMoveEvent", tankId: tankId)
                    let tankRaceMoveEvent: any ArkEvent = TankRaceMoveEvent(eventData: tankRaceMoveEventData)
                    eventContext.emit(tankRaceMoveEvent)
                }
                .label("Move", color: .black)
                .borderRadius(35)
                .borderColor(.black)
                .borderWidth(3)
                .background(color: .gray)
                .padding(top: 4, bottom: 4, left: 2, right: 2)
        ])
    }

    static func createFireButton(position: CGPoint,
                                 tankId: Int,
                                 zPosition: Double,
                                 in ecsContext: ArkECSContext,
                                 eventContext: ArkEventContext) -> Entity {
        ecsContext.createEntity(with: [
            ButtonRenderableComponent(width: 70, height: 70)
                .shouldRerender { old, new in
                    old.center != new.center
                }
                .center(position)
                .layer(.screen)
                .zPosition(zPosition)
                .onTap {
                    let tankShootEventData = TankShootEventData(name: "TankFireEvent", tankId: tankId)
                    let tankShootEvent: any ArkEvent = TankShootEvent(eventData: tankShootEventData)
                    eventContext.emit(tankShootEvent)
                }
                .label("Fire!", color: .black)
                .borderRadius(35)
                .borderColor(.black)
                .borderWidth(3)
                .background(color: .green)
                .padding(top: 4, bottom: 4, left: 2, right: 2)
        ])
    }

    static func createTerrainObjects(in ecsContext: ArkECSContext, objectsSpecs: [TankSpecification]) {
        let terrainObjectBuilder = TankRaceGameTerrainObjectBuilder(ecsContext: ecsContext)

        terrainObjectBuilder.buildObjects(from: objectsSpecs)
    }

    private static let tankIndexToImageAsset: [Int: TankRaceGameImages] = [
        1: .tank_1,
        2: .tank_2,
        3: .tank_3,
        4: .tank_4
    ]

    static func createTank(
        at position: CGPoint,
        rotation: CGFloat,
        tankIndex: Int,
        in ecsContext: ArkECSContext,
        zPosition: Double) -> Entity {
        let tankEntity = ecsContext.createEntity(with: [
            BitmapImageRenderableComponent(arkImageResourcePath: tankIndexToImageAsset[tankIndex] ?? .tank_1,
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

    static func createFinishLine(canvasWidth: CGFloat,
                                 canvasHeight: CGFloat,
                                 zPosition: Double,
                                 in ecsContext: ArkECSContext,
                                 eventContext: ArkEventContext) {
        let positions: [CGPoint] = [CGPoint(x: canvasWidth * 1 / 6, y: canvasWidth / 5),
                                    CGPoint(x: canvasWidth * 1 / 2, y: canvasWidth / 5),
                                    CGPoint(x: canvasWidth * 5 / 6, y: canvasWidth / 5)]
        let entities = positions.map {
            ecsContext.createEntity(with: [
                BitmapImageRenderableComponent(arkImageResourcePath: TankRaceGameImages.finish_line,
                                                                   width: canvasWidth / 3,
                                                                   height: canvasWidth / 5)
                    .center($0)
                    .zPosition(zPosition)
                    .scaleAspectFill(),
                PositionComponent(position: $0),
                RotationComponent(),
                PhysicsComponent(shape: .rectangle, size: CGSize(width: 80, height: 100),
                                 isDynamic: false, allowsRotation: false, restitution: 0,
                                 categoryBitMask: TankGamePhysicsCategory.water,
                                 collisionBitMask: TankGamePhysicsCategory.none,
                                 contactTestBitMask: TankGamePhysicsCategory.tank)
        ])
        }

    }
}
