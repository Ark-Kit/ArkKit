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
        self.blueprint = self.blueprint
            .setup({ ecsContext, eventContext in
                let tankEntity1 = TankGameEntityCreator.createTank(at: CGPoint(x: 500, y: 700), rotation: Double.pi,
                                                                   tankIndex: 1, in: ecsContext)
                let tankEntity2 = TankGameEntityCreator.createTank(at: CGPoint(x: 500, y: 300), rotation: 0,
                                                                   tankIndex: 2, in: ecsContext)

                TankGameEntityCreator.createJoyStick(center: CGPoint(x: 150, y: 1_030), tankEntity: tankEntity1,
                                                     in: ecsContext, eventContext: eventContext)
                TankGameEntityCreator.createJoyStick(center: CGPoint(x: 670, y: 150), tankEntity: tankEntity2,
                                                     in: ecsContext, eventContext: eventContext)

                TankGameEntityCreator.createShootButton(at: CGPoint(x: 670, y: 1_030), tankEntity: tankEntity1,
                                                        in: ecsContext, eventContext: eventContext)
                TankGameEntityCreator.createShootButton(at: CGPoint(x: 150, y: 150), tankEntity: tankEntity2,
                                                        in: ecsContext, eventContext: eventContext)

//                TankGameEntityCreator.addBackground(width: self.blueprint.frameWidth, height: self.blueprint.frameHeight,
//                                                    in: ecsContext)
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

                let velocityScale = 1.5

                if tankMoveEventData.magnitude == 0 {
                    tankPhysicsComponent.velocity = .zero
                    ecsContext.upsertComponent(tankPhysicsComponent, to: tankMoveEventData.tankEntity)
                } else {
                    tankRotationComponent.angleInRadians = tankMoveEventData.angle - Double.pi / 2

                    let velocityX = tankMoveEventData.magnitude * velocityScale
                                    * cos(tankMoveEventData.angle - Double.pi / 2)
                    let velocityY = tankMoveEventData.magnitude * velocityScale
                                    * sin(tankMoveEventData.angle - Double.pi / 2)

                    tankPhysicsComponent.velocity = CGVector(dx: velocityX, dy: velocityY)
                    ecsContext.upsertComponent(tankPhysicsComponent, to: tankMoveEventData.tankEntity)
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
                                velocity: CGVector(dx: ballVelocity * cos(tankRotationComponent.angleInRadians ?? 0),
                                                   dy: ballVelocity * sin(tankRotationComponent.angleInRadians ?? 0)),
                                angle: tankRotationComponent.angleInRadians ?? 0,
                                in: ecsContext)
            })
    }

}
