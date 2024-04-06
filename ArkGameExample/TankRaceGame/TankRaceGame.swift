import Foundation

class TankRaceGame {
    // ideally, i can set canavs size to be up to 10_000
    private(set) var blueprint = ArkBlueprint(frameWidth: 900, frameHeight: 1_000)
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
            let tank1Pos = CGPoint(x: 150, y: 800)
            let tank2Pos = CGPoint(x: 450, y: 800)
            let tank3Pos = CGPoint(x: 750, y: 800)

            let tank1 = TankGameEntityCreator.createTank(
                at: tank1Pos, rotation: 0.0, tankIndex: 1, in: ecs, zPosition: 1.0
            )

//            ecs.upsertComponent(PlacedCameraComponent(
//                camera: Camera(canvasPosition: tank1Pos, canvasSize: CGSize(width: self.blueprint.frameWidth,
//                                                                            height: self.blueprint.frameHeight)),
//                screenPosition: CGPoint(x: (screenWidth / 3) - screenWidthIncrement, y: screenHeight / 2),
////                canvasSize: CGSize(width: canvasWidth, height: canvasHeight),
//                size: CGSize(width: screenWidth / 3, height: screenHeight)
//            ), to: tank1)

            let tank2 = TankGameEntityCreator.createTank(
                at: tank2Pos, rotation: 0.0, tankIndex: 2, in: ecs, zPosition: 1.0
            )
            let tank3 = TankGameEntityCreator.createTank(
                at: tank3Pos, rotation: 0.0, tankIndex: 3, in: ecs, zPosition: 1.0
            )
            self.tankIdEntityMap[1] = tank1
            self.tankIdEntityMap[2] = tank2
            self.tankIdEntityMap[3] = tank3

//            ecs.upsertComponent(PlacedCameraComponent(
//                camera: Camera(canvasPosition: tank2Pos, canvasSize: CGSize(width: self.blueprint.frameWidth,
//                                                                            height: self.blueprint.frameHeight)),
//                screenPosition: CGPoint(x: 2 * (screenWidth / 3) - screenWidthIncrement, y: screenHeight / 2),
////                canvasSize: CGSize(width: canvasWidth, height: canvasHeight),
//                size: CGSize(width: screenWidth / 3, height: screenHeight)
//            ), to: tank2)
//
//            ecs.upsertComponent(PlacedCameraComponent(
//                camera: Camera(canvasPosition: tank3Pos, canvasSize: CGSize(width: self.blueprint.frameWidth,
//                                                                            height: self.blueprint.frameHeight)),
//                screenPosition: CGPoint(x: (screenWidth) - screenWidthIncrement, y: screenHeight / 2),
////                canvasSize: CGSize(width: canvasWidth, height: canvasHeight),
//                size: CGSize(width: screenWidth / 3, height: screenHeight)
//            ), to: tank3)

            TankGameEntityCreator.createJoyStick(
                center: CGPoint(x: screenWidth * 1 / 12, y: screenHeight * 7 / 8),
                tankId: 1,
                in: ecs,
                eventContext: events,
                zPosition: 999)
            TankGameEntityCreator.createJoyStick(
                center: CGPoint(x: screenWidth * 5 / 12, y: screenHeight * 7 / 8),
                tankId: 2,
                in: ecs,
                eventContext: events,
                zPosition: 999)
            TankGameEntityCreator.createJoyStick(
                center: CGPoint(x: screenWidth * 9 / 12, y: screenHeight * 7 / 8),
                tankId: 3,
                in: ecs,
                eventContext: events,
                zPosition: 999)
        }
        .on(TankMoveEvent.self) { event, context in
            self.handleTankMove(event, in: context)
        }
    }

    private func handleTankMove(_ event: TankMoveEvent, in context: ArkActionContext) {
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
}
