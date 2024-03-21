import Foundation

class TankGameManager {

    private(set) var blueprint: ArkBlueprint

    init(frameWidth: Double, frameHeight: Double) {
        // 820, 1180
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
                let tankEntity1 = TankGameEntityCreator.createTank(at: CGPoint(x: 500, y: 300),
                                                                   tankIndex: 1, in: ecsContext)
                let tankEntity2 = TankGameEntityCreator.createTank(at: CGPoint(x: 500, y: 700),
                                                                   tankIndex: 2, in: ecsContext)

                TankGameEntityCreator.createJoyStick(center: CGPoint(x: 670, y: 150), tankEntity: tankEntity1,
                                                     in: ecsContext, eventContext: eventContext)
                TankGameEntityCreator.createJoyStick(center: CGPoint(x: 150, y: 1_030), tankEntity: tankEntity2,
                                                     in: ecsContext, eventContext: eventContext)

//                ecsContext.createEntity(with: [
//                    JoystickCanvasComponent(center: CGPoint(x: 300, y: 300), radius: 50,
//                                            areValuesEqual: { _, _ in true })
//                        .onPanChange { angle, mag in print("change", angle, mag) }
//                        .onPanStart { angle, mag in print("start", angle, mag) }
//                        .onPanEnd { angle, mag in print("end", angle, mag) }
//                ])

//                ecsContext.createEntity(with: [
//                    ButtonCanvasComponent(width: 50, height: 50, center: CGPoint(x: 500, y: 500),
//                                          areValuesEqual: { _, _ in true })
//                    .addOnTapDelegate(delegate: {
//                        print("emiting event")
//                        var demoEvent: any ArkEvent = DemoArkEvent()
//                        eventContext.emit(&demoEvent)
//                        print("done emit event")
//                    })
//                ])
            })
            .rule(on: DemoArkEvent.self, then: Forever { _, _, _ in
                print("running rule")
            })

    }

    func setUpSystems() {
    }

    func setUpRules() {
        self.blueprint = self.blueprint
            .rule(on: TankMoveEvent.self, then: Forever { event, _, ecsContext in
                guard let tankMoveEvent = event as? TankMoveEvent,
                      let tankMoveEventData = tankMoveEvent.eventData as? TankMoveEventData,
                      var tankPhysicsComponent = ecsContext.getComponent(ofType: PhysicsComponent.self,
                                                                         for: tankMoveEventData.tankEntity)
                else {
                    return
                }

                let velocityScale = 0.1

                if tankMoveEventData.magnitude == 0 {
                    tankPhysicsComponent.velocity = .zero
                } else {
                    let velocityX = tankMoveEventData.magnitude * velocityScale
                                    * cos(tankMoveEventData.angle - Double.pi / 2)
                    let velocityY = tankMoveEventData.magnitude * velocityScale
                                    * sin(tankMoveEventData.angle - Double.pi / 2)

                    tankPhysicsComponent.velocity = CGVector(dx: velocityX, dy: velocityY)

                    // TODO: Delete this part once velocity works properly
                    if let positionComponent = ecsContext.getComponent(ofType: PositionComponent.self,
                                                                       for: tankMoveEventData.tankEntity) {
                        positionComponent.position.x += velocityX
                        positionComponent.position.y += velocityY

                    }
                }
            })


    }

}
