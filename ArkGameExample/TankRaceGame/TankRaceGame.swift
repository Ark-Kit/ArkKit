import Foundation

class TankRaceGame {
    private(set) var blueprint = ArkBlueprintWithoutSound(frameWidth: 900, frameHeight: 10_000)
    var joystick1: EntityID?
    var joystick2: EntityID?
    var joystick3: EntityID?
    var camera1: Entity?
    var camera2: Entity?
    var camera3: Entity?

    private var tankIdEntityMap = [Int: Entity]()

    func load() {
        blueprint = blueprint.setup { context in
            let ecs = context.ecs
            let events = context.events
            let display = context.display

            let screenWidth = display.screenSize.width
            let screenHeight = display.screenSize.height
            let canvasWidth = display.canvasSize.width
            let canvasHeight = display.canvasSize.height

            TankGameEntityCreator.createBackground(width: canvasWidth,
                                                   height: canvasHeight,
                                                   in: ecs,
                                                   zPosition: 0,
                                                   background: [[1, 1, 1], [2, 2, 2], [3, 3, 3]])

            TankGameEntityCreator.createBoundaries(width: canvasWidth, height: canvasHeight, in: ecs)

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
                    zoomHeight: 10.0
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
                               zoomHeight: 10.0),
                screenPosition: CGPoint(x: 2 * (screenWidth / 3) - screenWidthIncrement, y: screenHeight / 2),
                size: CGSize(width: screenWidth / 3, height: screenHeight)
            ), to: tank2)

            ecs.upsertComponent(PlacedCameraComponent(
                camera: Camera(canvasPosition: tank3Pos,
                               zoomWidth: 1,
                               zoomHeight: 10.0),
                screenPosition: CGPoint(x: (screenWidth) - screenWidthIncrement, y: screenHeight / 2),
                size: CGSize(width: screenWidth / 3, height: screenHeight)
            ), to: tank3)

            let joystick1 = TankGameEntityCreator.createJoyStick(
                center: CGPoint(x: screenWidth * 1 / 12, y: screenHeight * 7 / 8),
                tankId: 1,
                in: ecs,
                eventContext: events,
                zPosition: 999)
            self.joystick1 = joystick1.id
            let joystick2 = TankGameEntityCreator.createJoyStick(
                center: CGPoint(x: screenWidth * 5 / 12, y: screenHeight * 7 / 8),
                tankId: 2,
                in: ecs,
                eventContext: events,
                zPosition: 999)
            self.joystick2 = joystick2.id
            let joystick3 = TankGameEntityCreator.createJoyStick(
                center: CGPoint(x: screenWidth * 9 / 12, y: screenHeight * 7 / 8),
                tankId: 3,
                in: ecs,
                eventContext: events,
                zPosition: 999)
            self.joystick3 = joystick3.id
            self.camera1 = tank1
            self.camera2 = tank2
            self.camera3 = tank3
        }
        .on(TankMoveEvent.self) { event, context in
            self.handleTankMove(event, in: context)
        }
        .on(ScreenResizeEvent.self) { event, context in
            self.handleScreenResize(event, in: context)
        }
    }

    private func handleTankMove(_ event: TankMoveEvent, in context: ArkActionContext<NoSound>) {
        let ecs = context.ecs
        let tankMoveEventData = event.eventData
        guard let tankEntity = tankIdEntityMap[tankMoveEventData.tankId] else {
            return
        }

        guard var tankPhysicsComponent = ecs.getComponent(
            ofType: PhysicsComponent.self,
            for: tankEntity),
            var tankRotationComponent = ecs.getComponent(
                ofType: RotationComponent.self,
                for: tankEntity)
        else {
            return
        }

        let velocityScale = 1.5

        if tankMoveEventData.magnitude == 0 {
            tankPhysicsComponent.velocity = .zero
            tankPhysicsComponent.isDynamic = false
            ecs.upsertComponent(tankPhysicsComponent, to: tankEntity)
        } else {
            tankRotationComponent.angleInRadians = tankMoveEventData.angle
            ecs.upsertComponent(tankRotationComponent, to: tankEntity)
            let velocityX = tankMoveEventData.magnitude * velocityScale
                * cos(tankMoveEventData.angle - Double.pi / 2)
            let velocityY = tankMoveEventData.magnitude * velocityScale
                * sin(tankMoveEventData.angle - Double.pi / 2)
            tankPhysicsComponent.isDynamic = true
            tankPhysicsComponent.velocity = CGVector(dx: velocityX, dy: velocityY)
            ecs.upsertComponent(tankPhysicsComponent, to: tankEntity)
        }
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

        if let joystick1 = joystick1,
           let joystick1Entity = ecs.getEntity(id: joystick1) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 1 / 12, y: screenHeight * 7 / 8))
            ecs.upsertComponent(positionComponent, to: joystick1Entity)
        }

        if let joystick2 = joystick2,
           let joystick2Entity = ecs.getEntity(id: joystick2) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 5 / 12, y: screenHeight * 7 / 8))
            ecs.upsertComponent(positionComponent, to: joystick2Entity)
        }

        if let joystick3 = joystick3,
           let joystick3Entity = ecs.getEntity(id: joystick3) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 9 / 12, y: screenHeight * 7 / 8))
            ecs.upsertComponent(positionComponent, to: joystick3Entity)
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
}
