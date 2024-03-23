import Foundation

class TankGameManager {

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
        var frameWidth = blueprint.frameWidth
        var frameHeight = blueprint.frameHeight

        self.blueprint = self.blueprint
            .setup({ ecsContext, eventContext in
                TankGameEntityCreator.createBackground(width: frameWidth, height: frameHeight,
                                                    in: ecsContext, zPosition: 0, background: [[1, 1, 1], [2, 2, 2], [3, 3, 3]])
                TankGameEntityCreator.createTerrainObjects(in: ecsContext, objectsSpecs: [
                    (type: 0, location: CGPoint(x: frameWidth / 2, y: frameHeight / 2),
                     size: CGSize(width: frameWidth * 5 / 6, height: 100)),
                    (type: 1, location: CGPoint(x: frameWidth * 3 / 4, y: frameHeight * 3 / 4),
                            size: CGSize(width: 60, height: 60)),
                    (type: 3, location: CGPoint(x: frameWidth * 1 / 4, y: frameHeight * 1 / 4),
                            size: CGSize(width: 80, height: 80)),
                    (type: 2, location: CGPoint(x: frameWidth * 2 / 5, y: frameHeight * 3 / 5),
                            size: CGSize(width: 80, height: 80)),
                    (type: 4, location: CGPoint(x: frameWidth * 3 / 5, y: frameHeight * 2 / 5),
                            size: CGSize(width: 60, height: 60)),
                    (type: 5, location: CGPoint(x: frameWidth * 1 / 6, y: frameHeight * 3 / 7),
                            size: CGSize(width: 90, height: 90)),
                    (type: 6, location: CGPoint(x: frameWidth * 5 / 6, y: frameHeight * 4 / 7),
                            size: CGSize(width: 90, height: 90))
                ])

                let tankEntity1 = TankGameEntityCreator.createTank(at: CGPoint(x: 400, y: 1_000), rotation: 0,
                                                                   tankIndex: 1, in: ecsContext, zPosition: 5)
                let tankEntity2 = TankGameEntityCreator.createTank(at: CGPoint(x: 400, y: 180), rotation: Double.pi,
                                                                   tankIndex: 2, in: ecsContext, zPosition: 5)

                TankGameEntityCreator.createJoyStick(center: CGPoint(x: 150, y: 1_030), tankEntity: tankEntity1,
                                                     in: ecsContext, eventContext: eventContext, zPosition: 999)
                TankGameEntityCreator.createJoyStick(center: CGPoint(x: 670, y: 150), tankEntity: tankEntity2,
                                                     in: ecsContext, eventContext: eventContext, zPosition: 999)

                TankGameEntityCreator.createShootButton(at: CGPoint(x: 670, y: 1_030), tankEntity: tankEntity1,
                                                        in: ecsContext, eventContext: eventContext, zPosition: 999)
                TankGameEntityCreator.createShootButton(at: CGPoint(x: 150, y: 150), tankEntity: tankEntity2,
                                                        in: ecsContext, eventContext: eventContext, zPosition: 999)

            })

    }

    func setUpSystems() {
    }

    func setUpRules() {
        self.blueprint = self.blueprint
            .rule(on: TankMoveEvent.self, then: Forever { event, _, ecsContext in
                guard let tankMoveEvent = event as? TankMoveEvent,
                      let tankMoveEventData = tankMoveEvent.eventData as? TankMoveEventData,
                      var tankRotationComponent = ecsContext.getComponent(ofType: RotationComponent.self,
                                                                          for: tankMoveEventData.tankEntity),
                      var tankPhysicsComponent = ecsContext.getComponent(ofType: PhysicsComponent.self,
                                                                         for: tankMoveEventData.tankEntity)
                else {
                    return
                }

                let tankEntity = tankMoveEventData.tankEntity
                let velocityScale = 1.5

                if tankMoveEventData.magnitude == 0 {
                    tankPhysicsComponent.velocity = .zero
                    ecsContext.upsertComponent(tankPhysicsComponent, to: tankEntity)
                } else {
                    tankRotationComponent.angleInRadians = tankMoveEventData.angle
                    ecsContext.upsertComponent(tankRotationComponent, to: tankEntity)
                    let velocityX = tankMoveEventData.magnitude * velocityScale
                                    * cos(tankMoveEventData.angle - Double.pi / 2)
                    let velocityY = tankMoveEventData.magnitude * velocityScale
                                    * sin(tankMoveEventData.angle - Double.pi / 2)

                    tankPhysicsComponent.velocity = CGVector(dx: velocityX, dy: velocityY)
                    ecsContext.upsertComponent(tankPhysicsComponent, to: tankEntity)
                }
            })
            .rule(on: TankShootEvent.self, then: Forever { event, _, ecsContext in
                guard let tankShootEvent = event as? TankShootEvent,
                      let tankShootEventData = tankShootEvent.eventData as? TankShootEventData,
                      let tankPositionComponent = ecsContext.getComponent(ofType: PositionComponent.self,
                                                                          for: tankShootEventData.tankEntity),
                      let tankRotationComponent = ecsContext.getComponent(ofType: RotationComponent.self,
                                                                          for: tankShootEventData.tankEntity)
                else {
                    return
                }

                let ballVelocity = 300.0

                TankGameEntityCreator
                    .createBall(position: tankPositionComponent.position,
                                velocity: CGVector(dx: ballVelocity * cos((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2),
                                                   dy: ballVelocity * sin((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2)),
                                angle: tankRotationComponent.angleInRadians ?? 0,
                                in: ecsContext)
            })
    }

}
