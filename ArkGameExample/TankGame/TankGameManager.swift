import Foundation

class TankGameManager {
    var joystick1: EntityID?
    var joystick2: EntityID?
    var shootButton1: EntityID?
    var shootButton2: EntityID?
    var collisionStrategyManager = TankGameCollisionStrategyManager()

    private var tankIdEntityMap = [Int: Entity]()

    private(set) var blueprint: ArkBlueprint<TankGameSounds>

    init(frameWidth: Double, frameHeight: Double) {
        self.blueprint = ArkBlueprint(frameWidth: frameWidth, frameHeight: frameHeight)
        setUp()
    }

    func setUp() {
        setUpAudio()
        setUpEntities()
        setUpSystems()
        setUpRules()
    }

    func setUpAudio() {
        blueprint = blueprint.withAudio(tankGameSoundMapping)
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
                let canvasWidth = display.canvasSize.width
                let canvasHeight = display.canvasSize.height

                TankGameEntityCreator.createBackground(width: canvasWidth,
                                                       height: canvasHeight,
                                                       in: ecs,
                                                       zPosition: 0,
                                                       background: [[1, 1, 1], [2, 2, 2], [3, 3, 3]])

                TankGameEntityCreator.createBoundaries(width: canvasWidth, height: canvasHeight, in: ecs)

                self.createTankTerrainEntities(ecs: ecs, canvasWidth: canvasWidth, canvasHeight: canvasHeight)
                let tankEntity1 = TankGameEntityCreator.createTank(
                    with: TankCreationContext(position: CGPoint(x: canvasWidth / 2, y: 1_000),
                                              rotation: 0,
                                              tankIndex: 1,
                                              zPosition: 5,
                                              hp: 50),
                    in: ecs)
                self.tankIdEntityMap[1] = tankEntity1

                let tankEntity2 = TankGameEntityCreator.createTank(
                    with: TankCreationContext(position: CGPoint(x: 400, y: 180),
                                              rotation: Double.pi,
                                              tankIndex: 2,
                                              zPosition: 5,
                                              hp: 50),
                    in: ecs)
                self.tankIdEntityMap[2] = tankEntity2

                let joystick1Entity = TankGameEntityCreator.createJoyStick(
                    center: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 7 / 8),
                    tankId: 1,
                    in: ecs,
                    eventContext: events,
                    zPosition: 999)
                let joystick2Entity = TankGameEntityCreator.createJoyStick(
                    center: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 1 / 8),
                    tankId: 2,
                    in: ecs,
                    eventContext: events,
                    zPosition: 999)

                let shootButton1Entity = TankGameEntityCreator.createShootButton(
                    with: TankShootButtonCreationContext(
                        position: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 7 / 8),
                        tankId: 1,
                        zPosition: 999,
                        rotate: false
                    ),
                    in: ecs,
                    eventContext: events
                )
                let shootButton2Entity = TankGameEntityCreator.createShootButton(
                    with: TankShootButtonCreationContext(
                        position: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 1 / 8),
                        tankId: 2,
                        zPosition: 999,
                        rotate: true
                    ),
                    in: ecs,
                    eventContext: events
                )

                self.joystick1 = joystick1Entity.id
                self.joystick2 = joystick2Entity.id
                self.shootButton1 = shootButton1Entity.id
                self.shootButton2 = shootButton2Entity.id
            }
    }

    func setUpSystems() {
        blueprint = blueprint
            .forEachTick { _, _ in
//                print("first one", deltaTime)
            }
            .forEachTick { _, _ in
//                print("second one", deltaTime)
            }
    }

    func setUpRules() {
        blueprint = blueprint.setupMultiplayer(serviceName: "tankGame")

        blueprint = blueprint
            .on(ScreenResizeEvent.self) { event, context in
                self.handleScreenResize(event, in: context)
            }
            .on(TankMoveEvent.self) { event, context in
                self.handleTankMove(event, in: context)
            }
            .on(TankMoveEvent.self,
                executeIf: { _ in false }, { _ in true },
                then: { _, _ in
                print("will not execute")
            })
            .on(TankShootEvent.self) { event, context in
                self.handleTankShoot(event, in: context)
            }
            .on(TankHpModifyEvent.self) { event, context in
                self.handleTankHpModify(event, in: context)
            }
            .on(TankReviveEvent.self) { event, context in
                self.handleTankRevive(event, in: context)
            }
            .on(TankDestroyedEvent.self) { event, context in
                self.handleTankDestroyed(event, in: context)
            }
            .on(ArkCollisionBeganEvent.self) { event, context in
                self.handleContactBegan(event, in: context)
            }
            .on(ArkCollisionEndedEvent.self) { event, context in
                self.handleContactEnd(event, in: context)
            }
    }

    private func createTankTerrainEntities(ecs: ArkECSContext, canvasWidth: Double, canvasHeight: Double) {
        TankGameEntityCreator
            .createTerrainObjects(in: ecs,
                                  objectsSpecs: [
                                      TankSpecification(type: 0,
                                                        location: CGPoint(x: canvasWidth / 2,
                                                                          y: canvasHeight / 2),
                                                        size: CGSize(width: canvasWidth,
                                                                     height: canvasHeight / 5),
                                                        zPos: 1),
                                      TankSpecification(type: 1,
                                                        location: CGPoint(x: canvasWidth * 3 / 4,
                                                                          y: canvasHeight * 3 / 4),
                                                        size: CGSize(width: 100, height: 100),
                                                        zPos: 2),
                                      TankSpecification(type: 3,
                                                        location: CGPoint(x: canvasWidth * 1 / 4,
                                                                          y: canvasHeight * 1 / 4),
                                                        size: CGSize(width: 120, height: 120),
                                                        zPos: 2),
                                      TankSpecification(type: 2,
                                                        location: CGPoint(x: canvasWidth * 2 / 5,
                                                                          y: canvasHeight * 2 / 3),
                                                        size: CGSize(width: 70, height: 70),
                                                        zPos: 2),
                                      TankSpecification(type: 4,
                                                        location: CGPoint(x: canvasWidth * 3 / 5,
                                                                          y: canvasHeight * 1 / 3),
                                                        size: CGSize(width: 80, height: 80),
                                                        zPos: 2),
                                      TankSpecification(type: 1,
                                                        location: CGPoint(x: canvasWidth * 1 / 6,
                                                                          y: canvasHeight * 3 / 7),
                                                        size: CGSize(width: 80, height: 80),
                                                        zPos: 2),
                                      TankSpecification(type: 1,
                                                        location: CGPoint(x: canvasWidth * 5 / 6,
                                                                          y: canvasHeight * 4 / 7),
                                                        size: CGSize(width: 80, height: 80),
                                                        zPos: 2),
                                      TankSpecification(type: 3,
                                                        location: CGPoint(x: canvasWidth * 1 / 2,
                                                                          y: canvasHeight * 1 / 2),
                                                        size: CGSize(width: 85, height: 85),
                                                        zPos: 2),
                                      TankSpecification(type: 4,
                                                        location: CGPoint(x: canvasWidth * 7 / 8,
                                                                          y: canvasHeight * 1 / 3),
                                                        size: CGSize(width: 95, height: 95),
                                                        zPos: 2),
                                      TankSpecification(type: 5,
                                                        location: CGPoint(x: canvasWidth * 1 / 6,
                                                                          y: canvasHeight * 3 / 4),
                                                        size: CGSize(width: 90, height: 90),
                                                        zPos: 2),
                                      TankSpecification(type: 7,
                                                        location: CGPoint(x: canvasWidth * 1 / 3,
                                                                          y: canvasHeight * 1 / 2),
                                                        size: CGSize(width: 45, height: 45),
                                                        zPos: 2),
                                      TankSpecification(type: 7,
                                                        location: CGPoint(x: canvasWidth * 2 / 3,
                                                                          y: canvasHeight * 1 / 2),
                                                        size: CGSize(width: 45, height: 45),
                                                        zPos: 2)
                                  ])
    }
}

extension TankGameManager {
    private func handleScreenResize(_ event: ScreenResizeEvent, in context: ArkActionContext<TankGameSounds>) {
        let eventData = event.eventData
        let screenSize = eventData.newSize
        let ecs = context.ecs

        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        if let joystick1 = joystick1,
           let joystick1Entity = ecs.getEntity(id: joystick1) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 7 / 8))
            ecs.upsertComponent(positionComponent, to: joystick1Entity)
        }

        if let joystick2 = joystick2,
           let joystick2Entity = ecs.getEntity(id: joystick2) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 1 / 8))
            ecs.upsertComponent(positionComponent, to: joystick2Entity)
        }

        if let shootButton1 = shootButton1,
           let shootButton1Entity = ecs.getEntity(id: shootButton1) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 5 / 6, y: screenHeight * 7 / 8))
            ecs.upsertComponent(positionComponent, to: shootButton1Entity)
        }

        if let shootButton2 = shootButton2,
           let shootButton2Entity = ecs.getEntity(id: shootButton2) {
            let positionComponent = PositionComponent(
                position: CGPoint(x: screenWidth * 1 / 6, y: screenHeight * 1 / 8))
            ecs.upsertComponent(positionComponent, to: shootButton2Entity)
        }
    }

    private func handleTankMove(_ event: TankMoveEvent, in context: ArkActionContext<TankGameSounds>) {
        let ecs = context.ecs
        let tankMoveEventData = event.eventData
        guard let tankEntity = tankIdEntityMap[tankMoveEventData.tankId],
            var tankPhysicsComponent = ecs.getComponent(
            ofType: PhysicsComponent.self,
            for: tankEntity),
                    var tankRotationComponent = ecs.getComponent(
                ofType: RotationComponent.self,
                for: tankEntity) else {
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

    private func handleTankShoot(_ event: TankShootEvent, in context: ArkActionContext<TankGameSounds>) {
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
        context.audio.play(.shoot)
    }

    private func handleContactBegan(_ event: ArkCollisionBeganEvent, in context: ArkActionContext<TankGameSounds>) {
        let eventData = event.eventData

        let entityA = eventData.entityA
        let entityB = eventData.entityB
        let bitMaskA = eventData.entityACategoryBitMask
        let bitMaskB = eventData.entityBCategoryBitMask

        collisionStrategyManager.handleCollisionBegan(between: entityA, and: entityB,
                                                      bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                                      in: context)
    }

    private func handleContactEnd(_ event: ArkCollisionEndedEvent, in context: ArkActionContext<TankGameSounds>) {
        let eventData = event.eventData

        let entityA = eventData.entityA
        let entityB = eventData.entityB
        let bitMaskA = eventData.entityACategoryBitMask
        let bitMaskB = eventData.entityBCategoryBitMask

        collisionStrategyManager.handleCollisionEnded(between: entityA, and: entityB,
                                                      bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                                      in: context)
    }

    private func handleTankHpModify(_ event: TankHpModifyEvent, in context: ArkActionContext<TankGameSounds>) {
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
            let tankReviveEvent = TankReviveEvent(eventData: TankReviveEventData(name: "", tankEntity: tankEntity))
            context.events.emit(tankReviveEvent)
            let tankDestroyedEvent =
                    TankDestroyedEvent(eventData: TankDestroyedEventData(name: "Tank \(tankEntity) destroyed",
                                                                         tankEntity: tankEntity))
            context.events.emit(tankDestroyedEvent)
        }
    }

    private func handleTankRevive(_ event: TankReviveEvent, in context: ArkActionContext<TankGameSounds>) {
        let ecs = context.ecs
        let eventData = event.eventData
        let tankEntity = eventData.tankEntity
        guard var tankHpComponent = context.ecs.getComponent(ofType: TankHpComponent.self, for: tankEntity),
              !tankHpComponent.isRevived,
              let hpBarComponent = ecs.getComponent(ofType: RectRenderableComponent.self, for: tankEntity)
        else {
            return
        }
        tankHpComponent.hp = tankHpComponent.maxHp
        tankHpComponent.isRevived = true
        ecs.upsertComponent(tankHpComponent, to: tankEntity)
        let newHpBarComponent =
                    TankGameEntityCreator.createHpBarComponent(hp: tankHpComponent.maxHp,
                                                               zPosition: hpBarComponent.zPosition)
        ecs.upsertComponent(newHpBarComponent, to: tankEntity)
    }

    private func handleTankDestroyed(_ event: TankDestroyedEvent, in context: ArkActionContext<TankGameSounds>) {
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
            ImpactExplosionAnimation(perFrameDuration: 0.1).create(in: ecs, at: positionComponent.position)
        }
    }
}
