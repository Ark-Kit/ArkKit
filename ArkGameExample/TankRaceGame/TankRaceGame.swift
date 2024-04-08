import Foundation

class TankRaceGame {
    private(set) var blueprint: ArkBlueprintWithoutSound
    var moveButton1: EntityID?
    var moveButton2: EntityID?
    var moveButton3: EntityID?

    var fireButton1: EntityID?
    var fireButton2: EntityID?
    var fireButton3: EntityID?

    var camera1: Entity?
    var camera2: Entity?
    var camera3: Entity?

    var collisionStrategyManager = TankRaceGameCollisionStrategyManager()

    private var tankIdEntityMap = [Int: Entity]()

    init() {
        self.blueprint = ArkBlueprintWithoutSound(frameWidth: 900, frameHeight: 10_000)
        load()
    }

    func load() {
        blueprint = blueprint.setup { context in
            let ecs = context.ecs
            let events = context.events
            let display = context.display

            let screenWidth = display.screenSize.width
            let screenHeight = display.screenSize.height
            let canvasWidth = display.canvasSize.width
            let canvasHeight = display.canvasSize.height

            TankGameEntityCreator.createBackground(with: TankBackgroundCreationContext(width: canvasWidth,
                                                                                       height: canvasHeight,
                                                                                       zPosition: 0,
                                                                                       background: [[1, 2, 3],
                                                                                                    [1, 2, 3],
                                                                                                    [1, 2, 3]]),
                                                   in: ecs)

            TankGameEntityCreator.createBoundaries(width: canvasWidth, height: canvasHeight, in: ecs)
            self.createTankTerrainEntities(ecs: ecs, canvasWidth: canvasWidth, canvasHeight: canvasHeight)
            let screenWidthIncrement = screenWidth / 3 / 2

            let tank1Pos = CGPoint(x: 150, y: 9_800)
            let tank2Pos = CGPoint(x: 450, y: 9_800)
            let tank3Pos = CGPoint(x: 750, y: 9_800)

            let tank1 = self.createTank(
                at: tank1Pos, rotation: 0.0, tankIndex: 1, in: ecs, zPosition: 1.0
            )

            ecs.upsertComponent(PlacedCameraComponent(
                camera: Camera(
                    canvasPosition: tank1Pos,
                    zoomWidth: 1,
                    zoomHeight: 9
                ),
                screenPosition: CGPoint(x: (screenWidth / 3) - screenWidthIncrement, y: screenHeight / 2),
                size: CGSize(width: screenWidth / 3, height: screenHeight)
            ), to: tank1)

            let tank2 = self.createTank(
                at: tank2Pos, rotation: 0.0, tankIndex: 2, in: ecs, zPosition: 1.0
            )
            let tank3 = self.createTank(
                at: tank3Pos, rotation: 0.0, tankIndex: 3, in: ecs, zPosition: 1.0
            )
            self.tankIdEntityMap[1] = tank1
            self.tankIdEntityMap[2] = tank2
            self.tankIdEntityMap[3] = tank3

            ecs.upsertComponent(PlacedCameraComponent(
                camera: Camera(canvasPosition: tank2Pos,
                               zoomWidth: 1,
                               zoomHeight: 9),
                screenPosition: CGPoint(x: 2 * (screenWidth / 3) - screenWidthIncrement, y: screenHeight / 2),
                size: CGSize(width: screenWidth / 3, height: screenHeight)
            ), to: tank2)

            ecs.upsertComponent(PlacedCameraComponent(
                camera: Camera(canvasPosition: tank3Pos,
                               zoomWidth: 1,
                               zoomHeight: 9),
                screenPosition: CGPoint(x: (screenWidth) - screenWidthIncrement, y: screenHeight / 2),
                size: CGSize(width: screenWidth / 3, height: screenHeight)
            ), to: tank3)

            self.setupButtons(screenWidth: screenWidth, screenHeight: screenHeight,
                              events: events, ecs: ecs)

            self.camera1 = tank1
            self.camera2 = tank2
            self.camera3 = tank3
        }
        .on(TankRaceMoveEvent.self) { event, context in
            self.handleTankMove(event, in: context)
        }
        .on(ScreenResizeEvent.self) { event, context in
            self.handleScreenResize(event, in: context)
        }
        .on(ArkCollisionBeganEvent.self) { event, context in
            self.handleContactBegan(event, in: context)
        }
        .on(TankShootEvent.self) { event, context in
            self.handleTankShoot(event, in: context)
        }
        .on(TankHpModifyEvent.self) { event, context in
            self.handleRockHpModify(event, in: context)
        }
        .on(TankDestroyedEvent.self) { event, context in
            self.handleRockDestroyed(event, in: context)
        }
    }

    private func setupButtons(screenWidth: CGFloat, screenHeight: CGFloat,
                              events: ArkEventContext, ecs: ArkECSContext) {
        let moveButton1 = TankRaceGameEntityCreator.createMoveButton(
                                            position: CGPoint(x: screenWidth * 1 / 12,
                                                              y: screenHeight * 10 / 11),
                                            tankId: 1,
                                            zPosition: 999.0,
                                            in: ecs,
                                            eventContext: events)
        let moveButton2 = TankRaceGameEntityCreator.createMoveButton(
                                            position: CGPoint(x: screenWidth * 5 / 12,
                                                              y: screenHeight * 10 / 11),
                                            tankId: 2,
                                            zPosition: 999.0,
                                            in: ecs,
                                            eventContext: events)
        let moveButton3 = TankRaceGameEntityCreator.createMoveButton(
                                            position: CGPoint(x: screenWidth * 9 / 12,
                                                              y: screenHeight * 10 / 11),
                                            tankId: 3,
                                            zPosition: 999.0,
                                            in: ecs,
                                            eventContext: events)

        self.moveButton1 = moveButton1.id
        self.moveButton2 = moveButton2.id
        self.moveButton3 = moveButton3.id

        let fireButton1 = TankRaceGameEntityCreator.createFireButton(
                                            position: CGPoint(x: screenWidth * 3 / 12,
                                                              y: screenHeight * 10 / 11),
                                            tankId: 1,
                                            zPosition: 999.0,
                                            in: ecs,
                                            eventContext: events)
        let fireButton2 = TankRaceGameEntityCreator.createFireButton(
                                            position: CGPoint(x: screenWidth * 7 / 12,
                                                              y: screenHeight * 10 / 11),
                                            tankId: 2,
                                            zPosition: 999.0,
                                            in: ecs,
                                            eventContext: events)
        let fireButton3 = TankRaceGameEntityCreator.createFireButton(
                                            position: CGPoint(x: screenWidth * 11 / 12,
                                                              y: screenHeight * 10 / 11),
                                            tankId: 3,
                                            zPosition: 999.0,
                                            in: ecs,
                                            eventContext: events)

        self.fireButton1 = fireButton1.id
        self.fireButton2 = fireButton2.id
        self.fireButton3 = fireButton3.id
    }

    private func handleTankMove(_ event: TankRaceMoveEvent, in context: ArkActionContext<NoSound>) {
        let ecs = context.ecs
        let tankMoveEventData = event.eventData
        guard let tankEntity = tankIdEntityMap[tankMoveEventData.tankId] else {
            return
        }

        guard var tankPhysicsComponent = ecs.getComponent(
            ofType: PhysicsComponent.self,
            for: tankEntity)
        else {
            return
        }
        tankPhysicsComponent.velocity = .zero
        tankPhysicsComponent.isDynamic = true
        tankPhysicsComponent.velocity = CGVector(dx: 0, dy: -5_000)
        tankPhysicsComponent.linearDamping = 100
        ecs.upsertComponent(tankPhysicsComponent, to: tankEntity)
    }

    @discardableResult private func createTank(
        at position: CGPoint,
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

    private func handleScreenResize(_ event: ScreenResizeEvent, in context: ArkActionContext<NoSound>) {
        let eventData = event.eventData
        let screenSize = eventData.newSize
        let ecs = context.ecs

        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        if let moveButton1 = moveButton1,
           let button1Entity = ecs.getEntity(id: moveButton1) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 1 / 12, y: screenHeight * 10 / 11))
            ecs.upsertComponent(positionComponent, to: button1Entity)
        }

        if let moveButton2 = moveButton2,
           let button2Entity = ecs.getEntity(id: moveButton2) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 5 / 12, y: screenHeight * 10 / 11))
            ecs.upsertComponent(positionComponent, to: button2Entity)
        }

        if let moveButton3 = moveButton3,
           let button3Entity = ecs.getEntity(id: moveButton3) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 9 / 12, y: screenHeight * 10 / 11))
            ecs.upsertComponent(positionComponent, to: button3Entity)
        }

//        if let fireButton1 = fireButton1,
//           let button1Entity = ecs.getEntity(id: fireButton1) {
//            let positionComponent = PositionComponent(
//                position: CGPoint(x: screenWidth * 1 / 12, y: screenHeight * 8  / 9))
//            ecs.upsertComponent(positionComponent, to: button1Entity)
//        }
//
//        if let moveButton2 = moveButton2,
//           let button2Entity = ecs.getEntity(id: moveButton2) {
//            let positionComponent = PositionComponent(
//                position: CGPoint(x: screenWidth * 5 / 12, y: screenHeight * 8  / 9))
//            ecs.upsertComponent(positionComponent, to: button2Entity)
//        }
//
//        if let moveButton3 = moveButton3,
//           let button3Entity = ecs.getEntity(id: moveButton3) {
//            let positionComponent = PositionComponent(
//                position: CGPoint(x: screenWidth * 9 / 12, y: screenHeight * 8  / 9))
//            ecs.upsertComponent(positionComponent, to: button3Entity)
//        }

        adjustCameraOnResize(camera1, screenSize: screenSize, ecs: ecs, index: 1)
        adjustCameraOnResize(camera2, screenSize: screenSize, ecs: ecs, index: 2)
        adjustCameraOnResize(camera3, screenSize: screenSize, ecs: ecs, index: 3)
    }

    private func adjustCameraOnResize(_ camera: Entity?, screenSize: CGSize, ecs: ArkECSContext, index: Int) {
        let id = CGFloat(index)
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let screenWidthIncrement = screenWidth / 3 / 2

        if let cam = camera {
            if let placedCameraComponent = ecs.getComponent(ofType: PlacedCameraComponent.self, for: cam) {
                let updatedPlacedCameraComponent = PlacedCameraComponent(
                    camera: placedCameraComponent.camera,
                    screenPosition: CGPoint(x: id * (screenWidth / 3) - screenWidthIncrement, y: screenHeight / 2),
                    size: CGSize(width: screenWidth / 3, height: screenHeight)
                )
                ecs.upsertComponent(updatedPlacedCameraComponent, to: cam)
            }
        }
    }

    private func createTankTerrainEntities(ecs: ArkECSContext, canvasWidth: Double, canvasHeight: Double) {
        let tankTerrainSpecs = (1...3).flatMap { id in
            createTerrainForPlayer(id, canvasWidth: canvasWidth, canvasHeight: canvasHeight)
        }

        TankRaceGameEntityCreator.createTerrainObjects(in: ecs, objectsSpecs: tankTerrainSpecs)
    }

    private func createTerrainForPlayer(_ id: Int, canvasWidth: Double, canvasHeight: Double) -> [TankSpecification] {
        let fractions: [(Double, Int)] = [(3.0 / 10, 1), (5.0 / 10, 3), (6.0 / 10, 2), (9.0 / 10, 5)]
        return fractions.map {
            TankSpecification(
                type: $1,
                location: CGPoint(x: canvasWidth * (Double(id) / 3 - 1 / 6), y: canvasHeight * $0),
                size: CGSize(width: canvasWidth * 1 / 6, height: canvasWidth * 1 / 6),
                zPos: 1
            )
        }
    }

    private func handleContactBegan(_ event: ArkCollisionBeganEvent, in context: ArkActionContext<NoSound>) {
        let eventData = event.eventData

        let entityA = eventData.entityA
        let entityB = eventData.entityB
        let bitMaskA = eventData.entityACategoryBitMask
        let bitMaskB = eventData.entityBCategoryBitMask

        collisionStrategyManager.handleCollisionBegan(between: entityA, and: entityB,
                                                      bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                                      in: context)
    }

    private func handleTankShoot(_ event: TankShootEvent, in context: ArkActionContext<NoSound>) {
        let ecs = context.ecs
        let eventData = event.eventData
        guard let tankEntity = tankIdEntityMap[eventData.tankId],
              let tankPositionComponent = ecs.getComponent(ofType: PositionComponent.self, for: tankEntity),
              let tankRotationComponent = ecs.getComponent(ofType: RotationComponent.self, for: tankEntity),
              let tankPhysicsComponent = ecs.getComponent(ofType: PhysicsComponent.self, for: tankEntity) else {
            return
        }
        let tankLength = (tankPhysicsComponent.size?.height ?? 0.0) / 2 + 20

        let dx = cos((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2)
        let dy = sin((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2)
        let ballRadius = 15.0
        let ballVelocity = 300.0

        TankGameEntityCreator
            .createBall(with: TankBallCreationContext(
                position: CGPoint(x: tankPositionComponent.position.x + dx * (tankLength + ballRadius * 1.1),
                                  y: tankPositionComponent.position.y + dy * (tankLength + ballRadius * 1.1)),
                radius: ballRadius,
                velocity: CGVector(dx: ballVelocity * dx,
                                   dy: ballVelocity * dy),
                angle: tankRotationComponent.angleInRadians ?? 0,
                zPosition: 5),
                in: ecs)
    }

    private func handleRockHpModify(_ event: TankHpModifyEvent, in context: ArkActionContext<NoSound>) {
        let ecs = context.ecs
        let eventData = event.eventData
        let tankEntity = eventData.tankEntity
        guard var tankHpComponent = ecs.getComponent(ofType: TankHpComponent.self, for: tankEntity),
              let hpBarComponent = ecs.getComponent(ofType: RectRenderableComponent.self, for: tankEntity) else {
            return
        }
        let hpChange = eventData.hpChange
        let newHp = tankHpComponent.hp + hpChange
        tankHpComponent.hp = newHp
        ecs.upsertComponent(tankHpComponent, to: tankEntity)
        let newHpBarComponent =
                    TankGameEntityCreator.createHpBarComponent(hp: newHp, zPosition: hpBarComponent.zPosition)
        ecs.upsertComponent(newHpBarComponent, to: tankEntity)

        if newHp <= 0 {
            let tankDestroyedEvent =
                    TankDestroyedEvent(eventData: TankDestroyedEventData(name: "Tank \(tankEntity) destroyed",
                                                                         tankEntity: tankEntity))
            context.events.emit(tankDestroyedEvent)
        }
    }

    private func handleRockDestroyed(_ event: TankDestroyedEvent, in context: ArkActionContext<NoSound>) {
        let ecs = context.ecs
        let eventData = event.eventData
        let tankEntity = eventData.tankEntity
        guard let tankHpComponent = context.ecs.getComponent(ofType: TankHpComponent.self, for: tankEntity),
              tankHpComponent.hp <= 0,
              var physicsComponent = context.ecs.getComponent(ofType: PhysicsComponent.self, for: tankEntity) else {
            return
        }
        physicsComponent.toBeRemoved = true
        context.ecs.upsertComponent(physicsComponent, to: tankEntity)
        if let positionComponent = context.ecs.getComponent(ofType: PositionComponent.self, for: tankEntity) {
            ImpactExplosionAnimation(perFrameDuration: 0.1, width: 256.0, height: 256.0).create(in: ecs, at: positionComponent.position)
        }
    }
}
