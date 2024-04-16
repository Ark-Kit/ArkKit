import Foundation

class TankRaceGame {
    private(set) var blueprint: ArkBlueprint<TankRaceGameExternalResources>
    var moveButton1: EntityID?
    var moveButton2: EntityID?
    var moveButton3: EntityID?

    var joystick1: EntityID?
    var joystick2: EntityID?
    var joystick3: EntityID?

    var fireButton1: EntityID?
    var fireButton2: EntityID?
    var fireButton3: EntityID?

    var camera1: Entity?
    var camera2: Entity?
    var camera3: Entity?

    var finishLineEntities: [Entity] = []

    private var tankIdEntityMap = [Int: Entity]()
    var handlerManager: TankRaceEventHandler?
    var rootView: AbstractDemoGameHostingPage

    init(rootView: AbstractDemoGameHostingPage) {
        self.rootView = rootView
        self.blueprint = ArkBlueprint(frameWidth: 900, frameHeight: 10_000)
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

            TankGameEntityCreator.createBackground(with: TankBackgroundCreationContext(
                width: canvasWidth, height: canvasHeight, zPosition: 0,
                background: [[1, 2, 3], [1, 2, 3], [1, 2, 3]]),
                                                   in: ecs)
            self.finishLineEntities = TankRaceGameEntityCreator.createFinishLine(
                canvasWidth: canvasWidth, canvasHeight: canvasHeight, zPosition: 1, in: ecs, eventContext: events)
            TankGameEntityCreator.createBoundaries(width: canvasWidth, height: canvasHeight, in: ecs)
            self.createTankTerrainEntities(ecs: ecs, canvasWidth: canvasWidth, canvasHeight: canvasHeight)
            let screenWidthIncrement = screenWidth / 3 / 2

            let tank1Pos = CGPoint(x: 150, y: 9_800)
            let tank2Pos = CGPoint(x: 450, y: 9_800)
            let tank3Pos = CGPoint(x: 750, y: 9_800)

            let tank1 = TankRaceGameEntityCreator.createTank(
                at: tank1Pos, rotation: 0.0, tankIndex: 1, in: ecs, zPosition: 2
            )

            ecs.upsertComponent(PlacedCameraComponent(
                camera: Camera(canvasPosition: tank1Pos, zoomWidth: 1, zoomHeight: 9),
                screenPosition: CGPoint(x: (screenWidth / 3) - screenWidthIncrement, y: screenHeight / 2),
                size: CGSize(width: screenWidth / 3, height: screenHeight)
            ), to: tank1)

            let tank2 = TankRaceGameEntityCreator.createTank(
                at: tank2Pos, rotation: 0.0, tankIndex: 2, in: ecs, zPosition: 2
            )
            let tank3 = TankRaceGameEntityCreator.createTank(
                at: tank3Pos, rotation: 0.0, tankIndex: 3, in: ecs, zPosition: 2
            )
            self.tankIdEntityMap[1] = tank1
            self.tankIdEntityMap[2] = tank2
            self.tankIdEntityMap[3] = tank3

            ecs.upsertComponent(PlacedCameraComponent(
                camera: Camera(canvasPosition: tank2Pos, zoomWidth: 1, zoomHeight: 9),
                screenPosition: CGPoint(x: 2 * (screenWidth / 3) - screenWidthIncrement, y: screenHeight / 2),
                size: CGSize(width: screenWidth / 3, height: screenHeight)
            ), to: tank2)

            ecs.upsertComponent(PlacedCameraComponent(
                camera: Camera(canvasPosition: tank3Pos, zoomWidth: 1, zoomHeight: 9),
                screenPosition: CGPoint(x: (screenWidth) - screenWidthIncrement, y: screenHeight / 2),
                size: CGSize(width: screenWidth / 3, height: screenHeight)
            ), to: tank3)

            self.setupButtons(screenWidth: screenWidth, screenHeight: screenHeight,
                              events: events, ecs: ecs)

            self.camera1 = tank1
            self.camera2 = tank2
            self.camera3 = tank3
            self.handlerManager = TankRaceEventHandler(tankIdEntityMap: self.tankIdEntityMap,
                                                       finishLineEntities: self.finishLineEntities)
        }
        .on(TankRacePedalEvent.self) { event, context in
            self.handlerManager?.handleTankPedal(event, in: context)
        }
        .on(TankRaceEndPedalEvent.self) { event, context in
            self.handlerManager?.handleTankPedalEnd(event, in: context)
        }
        .on(ScreenResizeEvent.self) { event, context in
            self.handleScreenResize(event, in: context)
        }
        .on(ArkCollisionBeganEvent.self) { event, context in
            self.handlerManager?.handleContactBegan(event, in: context)

        }
        .on(TankShootEvent.self) { event, context in
            self.handlerManager?.handleTankShoot(event, in: context)
        }
        .on(TankHpModifyEvent.self) { event, context in
            self.handlerManager?.handleRockHpModify(event, in: context)
        }
        .on(TankDestroyedEvent.self) { event, context in
            self.handlerManager?.handleRockDestroyed(event, in: context)
        }
        .on(TankRaceSteeringEvent.self) { event, context in
            self.handlerManager?.handleTankSteer(event, in: context)
        }
        .on(TankWinEvent.self) { event, context in
            self.handlerManager?.handleWin(event, view: self.rootView)
            guard let stopwatchEntity = context.ecs.getEntities(with: [StopWatchComponent.self]).first,
                  let stopwatchComp = context.ecs
                .getComponent(ofType: StopWatchComponent.self, for: stopwatchEntity) else {
                return
            }
            context.events.emit(TerminateGameLoopEvent(
                eventData: TerminateGameLoopEventData(timeInGame: stopwatchComp.currentTime))
            )
        }
    }

    private func setupButtons(screenWidth: CGFloat, screenHeight: CGFloat,
                              events: ArkEventContext, ecs: ArkECSContext) {
        let moveButton1 = TankRaceGameEntityCreator.createMoveButton(
            position: CGPoint(x: screenWidth * 1 / 12, y: screenHeight * 10 / 11),
            tankId: 1, zPosition: 999.0, in: ecs, eventContext: events)
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

        let joystick1 = TankRaceGameEntityCreator.createJoyStick(
            center: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 7 / 8),
            tankId: 1,
            in: ecs,
            eventContext: events,
            zPosition: 999
        )
        let joystick2 = TankRaceGameEntityCreator.createJoyStick(
            center: CGPoint(x: screenWidth * 3 / 6, y: screenHeight * 7 / 8),
            tankId: 2,
            in: ecs,
            eventContext: events,
            zPosition: 999
        )
        let joystick3 = TankRaceGameEntityCreator.createJoyStick(
            center: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 7 / 8),
            tankId: 3,
            in: ecs,
            eventContext: events,
            zPosition: 999
        )

        self.joystick1 = joystick1.id
        self.joystick2 = joystick2.id
        self.joystick3 = joystick3.id
    }

    private func handleScreenResize(_ event: ScreenResizeEvent, in context: TankRaceGameActionContext) {
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

    private func createTerrainForPlayer(_ id: Int, canvasWidth: Double, canvasHeight: Double) -> [TankPropSpecification] {
        let fractions: [(Double, Int)] = [(3.0 / 10, 1), (5.0 / 10, 3), (6.0 / 10, 2), (9.0 / 10, 5)]
        return fractions.map {
            TankPropSpecification(
                type: $1,
                location: CGPoint(x: canvasWidth * (Double(id) / 3 - 1 / 6), y: canvasHeight * $0),
                size: CGSize(width: canvasWidth * 1 / 6, height: canvasWidth * 1 / 6),
                zPos: 1
            )
        }
    }
}
