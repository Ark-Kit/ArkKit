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
        blueprint = blueprint
            .setup { context in
                let ecs = context.ecs
                let events = context.events
                let display = context.display

                let screenWidth = display.screenSize.width
                let screenHeight = display.screenSize.height

                let tankEntity1 = TankGameEntityCreator.createTank(
                    at: CGPoint(x: 500, y: 700),
                    rotation: Double.pi,
                    tankIndex: 1,
                    in: ecs)
                let tankEntity2 = TankGameEntityCreator.createTank(
                    at: CGPoint(x: 500, y: 300),
                    rotation: 0,
                    tankIndex: 2,
                    in: ecs)

                TankGameEntityCreator.createJoyStick(
                    center: CGPoint(x: screenWidth * 3 / 4, y: screenHeight / 4),
                    tankEntity: tankEntity1,
                    in: ecs,
                    eventContext: events)

                TankGameEntityCreator.createJoyStick(
                    center: CGPoint(x: screenWidth / 4, y: screenHeight * 3 / 4),
                    tankEntity: tankEntity2,
                    in: ecs,
                    eventContext: events)

                TankGameEntityCreator.createShootButton(
                    at: CGPoint(x: 670, y: 1_030),
                    tankEntity: tankEntity1,
                    in: ecs,
                    eventContext: events)
                TankGameEntityCreator.createShootButton(
                    at: CGPoint(x: 150, y: 150), tankEntity: tankEntity2,
                    in: ecs,
                    eventContext: events)

//                TankGameEntityCreator.addBackground(width: self.blueprint.frameWidth, height: self.blueprint.frameHeight,
//                                                    in: ecsContext)
            }
    }

    func setUpSystems() {}

    func setUpRules() {
        blueprint = blueprint
            .rule(on: TankMoveEvent.self, then: Forever { event, context in
                let ecs = context.ecs

                guard let eventData = event.eventData else {
                    return
                }

                guard var tankPhysicsComponent = ecs.getComponent(
                    ofType: PhysicsComponent.self,
                    for: eventData.tankEntity)
                else {
                    return
                }
                
                let velocityScale = 1.5

                let velocityX = eventData.magnitude * velocityScale
                    * cos(eventData.angle - Double.pi / 2)
                let velocityY = eventData.magnitude * velocityScale
                        * sin(eventData.angle - Double.pi / 2)
                
                tankPhysicsComponent.velocity = CGVector(dx: velocityX, dy: velocityY)
                ecs.upsertComponent(tankPhysicsComponent, to: eventData.tankEntity)
            })
            .rule(on: TankShootEvent.self, then: Forever { event, context in
                let ecs = context.ecs
                
                guard let eventData = event.eventData else {
                    return
                }

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

                let ballVelocity = 300.0

                TankGameEntityCreator
                    .createBall(position: tankPositionComponent.position,
                                velocity: CGVector(dx: ballVelocity * cos(tankRotationComponent.angleInRadians ?? 0),
                                                   dy: ballVelocity * sin(tankRotationComponent.angleInRadians ?? 0)),
                                angle: tankRotationComponent.angleInRadians ?? 0,
                                in: ecs)
            })
    }
}
