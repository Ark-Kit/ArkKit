import Foundation

class TankGameManager {
    var joystick1: EntityID?
    var joystick2: EntityID?
    var collisionStrategyManager = TankGameCollisionStrategyManager()

    private(set) var blueprint: ArkBlueprint

    init(frameWidth: Double, frameHeight: Double) {
        self.blueprint = ArkBlueprint(frameWidth: frameWidth, frameHeight: frameHeight)
        setUp()
    }

    func setUp() {
        setUpEntities()
        setUpSystems()
        setUpRules()
    }

    func setUpEntities() {
        // Define game with blueprint here.
        blueprint = blueprint
            .setup { context in
                let ecs = context.ecs
                let events = context.events
                let display = context.display

                let screenWidth = display.screenSize.width
                let screenHeight = display.screenSize.height

                TankGameEntityCreator.createBackground(width: screenWidth,
                                                       height: screenHeight,
                                                       in: ecs,
                                                       zPosition: 0,
                                                       background: [[1, 1, 1], [2, 2, 2], [3, 3, 3]]
                )

                TankGameEntityCreator.createBoundaries(width: screenWidth, height: screenHeight, in: ecs)

                self.createTankEntities(ecs: ecs, screenWidth: screenWidth, screenHeight: screenHeight)

                let tankEntity1 = TankGameEntityCreator.createTank(
                    at: CGPoint(x: 400, y: 1_000),
                    rotation: 0,
                    tankIndex: 1,
                    in: ecs,
                    zPosition: 5)
                let tankEntity2 = TankGameEntityCreator.createTank(
                    at: CGPoint(x: 400, y: 180),
                    rotation: Double.pi,
                    tankIndex: 2,
                    in: ecs,
                    zPosition: 5)

                let joystick1Entity = TankGameEntityCreator.createJoyStick(
                    center: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 7 / 8),
                    tankEntity: tankEntity1,
                    in: ecs,
                    eventContext: events,
                    zPosition: 999)
                let joystick2Entity = TankGameEntityCreator.createJoyStick(
                    center: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 1 / 8),
                    tankEntity: tankEntity2,
                    in: ecs,
                    eventContext: events,
                    zPosition: 999)
                self.joystick1 = joystick1Entity.id
                self.joystick2 = joystick2Entity.id

                TankGameEntityCreator.createShootButton(
                    at: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 7 / 8),
                    tankEntity: tankEntity1,
                    in: ecs,
                    eventContext: events,
                    zPosition: 999)
                TankGameEntityCreator.createShootButton(
                    at: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 1 / 8),
                    tankEntity: tankEntity2,
                    in: ecs,
                    eventContext: events,
                    zPosition: 999)
            }
    }

    func setUpSystems() {}

    func setUpRules() {
        blueprint = blueprint
            .rule(on: ScreenResizeEvent.self, then: Forever { event, context in
                self.handleScreenResize(event, in: context)
            })
//            .rule(on: TankStartMoveEvent.self, then: Forever { event, context in
//                context.audio.play(TankMoveSound(), playerId: event.eventData.tankEntity.id)
//            })
//            .rule(on: TankStopMoveEvent.self, then: Forever { event, context in
//                context.audio.stop(TankMoveSound(), playerId: event.eventData.tankEntity.id)
//            })
            .rule(on: TankMoveEvent.self, then: Forever { event, context in
                self.handleTankMove(event, in: context)
            })
            .rule(on: TankShootEvent.self, then: Forever { event, context in
                self.handleTankShoot(event, in: context)
            })
            .rule(on: ArkCollisionBeganEvent.self, then: Forever { event, context in
                self.handleContactBegan(event, in: context)
            })
            .rule(on: ArkCollisionEndedEvent.self, then: Forever { event, context in
                self.handleContactEnd(event, in: context)
            })
    }
    private func createTankEntities(ecs: ArkECSContext, screenWidth: Double, screenHeight: Double) {
        TankGameEntityCreator.createTerrainObjects(in: ecs,
                                                   objectsSpecs: [
                                                       TankSpecification(
                                                        type: 0,
                                                        location: CGPoint(x: screenWidth / 2,
                                                                          y: screenHeight / 2),
                                                        size: CGSize(width: screenWidth,
                                                                     height: screenHeight / 5),
                                                        zPos: 1),
                                                       TankSpecification(
                                                        type: 1,
                                                        location: CGPoint(x: screenWidth * 3 / 4,
                                                                          y: screenHeight * 3 / 4),
                                                        size: CGSize(width: 100, height: 100),
                                                        zPos: 2),
                                                       TankSpecification(
                                                        type: 3,
                                                        location: CGPoint(x: screenWidth * 1 / 4,
                                                                          y: screenHeight * 1 / 4),
                                                        size: CGSize(width: 120, height: 120),
                                                        zPos: 2),
                                                       TankSpecification(
                                                        type: 2,
                                                        location: CGPoint(x: screenWidth * 2 / 5,
                                                                          y: screenHeight * 2 / 3),
                                                        size: CGSize(width: 70, height: 70),
                                                        zPos: 2),
                                                       TankSpecification(
                                                        type: 4,
                                                        location: CGPoint(x: screenWidth * 3 / 5,
                                                                          y: screenHeight * 1 / 3),
                                                        size: CGSize(width: 80, height: 80),
                                                        zPos: 2),
                                                       TankSpecification(
                                                        type: 1,
                                                        location: CGPoint(x: screenWidth * 1 / 6,
                                                                          y: screenHeight * 3 / 7),
                                                        size: CGSize(width: 80, height: 80),
                                                        zPos: 2),
                                                       TankSpecification(
                                                        type: 1,
                                                        location: CGPoint(x: screenWidth * 5 / 6,
                                                                          y: screenHeight * 4 / 7),
                                                        size: CGSize(width: 80, height: 80),
                                                        zPos: 2),
                                                       TankSpecification(
                                                        type: 3,
                                                        location: CGPoint(x: screenWidth * 1 / 2,
                                                                          y: screenHeight * 1 / 2),
                                                        size: CGSize(width: 85, height: 85),
                                                        zPos: 2),
                                                       TankSpecification(
                                                        type: 4,
                                                        location: CGPoint(x: screenWidth * 7 / 8,
                                                                          y: screenHeight * 1 / 3),
                                                        size: CGSize(width: 95, height: 95),
                                                        zPos: 2),
                                                       TankSpecification(
                                                        type: 5,
                                                        location: CGPoint(x: screenWidth * 1 / 6,
                                                                          y: screenHeight * 3 / 4),
                                                        size: CGSize(width: 90, height: 90),
                                                        zPos: 2)
                                                      ])
    }
}

extension TankGameManager {
    private func handleScreenResize(_ event: ScreenResizeEvent, in context: ArkActionContext) {
        let eventData = event.eventData
        let screenSize = eventData.newSize
        let ecs = context.ecs

        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        if let joystick1 = self.joystick1,
           let joystick1Entity = ecs.getEntity(id: joystick1) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 7 / 8))
            ecs.upsertComponent(positionComponent, to: joystick1Entity)
        }

        if let joystick2 = self.joystick2,
           let joystick2Entity = ecs.getEntity(id: joystick2) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 1 / 8))
            ecs.upsertComponent(positionComponent, to: joystick2Entity)
        }
    }

    private func handleTankMove(_ event: TankMoveEvent, in context: ArkActionContext) {
        let ecs = context.ecs
        let tankMoveEventData = event.eventData

        guard var tankPhysicsComponent = ecs.getComponent(
            ofType: PhysicsComponent.self,
            for: tankMoveEventData.tankEntity),
              var tankRotationComponent = ecs.getComponent(
                ofType: RotationComponent.self,
                for: tankMoveEventData.tankEntity)
        else {
            return
        }

        let tankEntity = tankMoveEventData.tankEntity
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

    private func handleTankShoot(_ event: TankShootEvent, in context: ArkActionContext) {
        let ecs = context.ecs
        let eventData = event.eventData

        guard let tankPositionComponent = ecs.getComponent(
           ofType: PositionComponent.self,
           for: eventData.tankEntity) else {
           return
        }

        guard let tankRotationComponent = ecs.getComponent(
               ofType: RotationComponent.self,
               for: eventData.tankEntity) else {
           return
        }

        guard let tankPhysicsComponent = ecs.getComponent(ofType: PhysicsComponent.self,
                                                          for: eventData.tankEntity) else {
        return }

        let tankLength = (tankPhysicsComponent.size?.height ?? 0.0) / 2

        let dx = cos((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2)
        let dy = sin((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2)

        let ballVelocity = 300.0

        TankGameEntityCreator
           .createBall(position: CGPoint(x: tankPositionComponent.position.x + dx * tankLength,
                                         y: tankPositionComponent.position.y + dy * tankLength),
                       velocity: CGVector(dx: ballVelocity * dx,
                                          dy: ballVelocity * dy),
                       angle: tankRotationComponent.angleInRadians ?? 0,
                       in: ecs,
                       zPosition: 5)
        context.audio.play(TankShootSound())
    }

    private func handleContactBegan(_ event: ArkCollisionBeganEvent, in context: ArkActionContext) {
        let eventData = event.eventData

        let entityA = eventData.entityA
        let entityB = eventData.entityB
        let bitMaskA = eventData.entityACategoryBitMask
        let bitMaskB = eventData.entityBCategoryBitMask

        collisionStrategyManager.handleCollisionBegan(between: entityA, and: entityB,
                                                      bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                                      in: context)
    }

    private func handleContactEnd(_ event: ArkCollisionEndedEvent, in context: ArkActionContext) {
        let eventData = event.eventData

        let entityA = eventData.entityA
        let entityB = eventData.entityB
        let bitMaskA = eventData.entityACategoryBitMask
        let bitMaskB = eventData.entityBCategoryBitMask

        collisionStrategyManager.handleCollisionEnded(between: entityA, and: entityB,
                                                      bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                                      in: context)
    }
}
