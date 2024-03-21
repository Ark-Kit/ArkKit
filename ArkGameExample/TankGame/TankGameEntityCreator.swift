import Foundation

struct TankGameEntityCreator {

    @discardableResult
    static func createTank(at position: CGPoint, tankIndex: Int,
                           in ecsContext: ArkECSContext) -> Entity {
        let tankEntity = ecsContext.createEntity(with: [
            BitmapImageCanvasComponent(imageResourcePath: "tank_\(tankIndex)", center: position, width: 80, height: 100)
                .scaleAspectFill(),
            PositionComponent(position: position),
            // TODO: Set up physics
            PhysicsComponent(shape: .rectangle, size: CGSize(width: 80, height: 100), categoryBitMask: 0,
                             collisionBitMask: 0, contactTestBitMask: 0)
        ])
        return tankEntity
    }

    static func createJoyStick(center: CGPoint, tankEntity: Entity, in ecsContext: ArkECSContext,
                               eventContext: ArkEventContext) {
        ecsContext.createEntity(with: [
            JoystickCanvasComponent(center: center, radius: 40, areValuesEqual: { _, _ in true })
                .onPanChange { angle, mag in
                    let tankMoveEventData = TankMoveEventData(name: "TankMoveEvent", tankEntity: tankEntity,
                                                              angle: angle, magnitude: mag)
                    var tankMoveEvent: any ArkEvent = TankMoveEvent(eventData: tankMoveEventData)
                    print("emitting event")
                    eventContext.emit(&tankMoveEvent)
                }
                .onPanEnd { _, _ in
                    let tankMoveEventData = TankMoveEventData(name: "TankMoveEvent", tankEntity: tankEntity,
                                                              angle: 0, magnitude: 0)
                    var tankMoveEvent: any ArkEvent = TankMoveEvent(eventData: tankMoveEventData)
                    eventContext.emit(&tankMoveEvent)
                }
        ])
    }

    static func createShootButton(center: CGPoint, tankEntity: Entity, in ecsContext: ArkECSContext,
                               eventContext: ArkEventContext) {
        ecsContext.createEntity(with: [
            ButtonCanvasComponent(width: 50, height: 50, center: CGPoint(x: 500, y: 500),
                                  areValuesEqual: { _, _ in true })
            .addOnTapDelegate(delegate: {
                print("emiting event")
                var demoEvent: any ArkEvent = DemoArkEvent()
                eventContext.emit(&demoEvent)
                print("done emit event")
            })
        ])
    }
}
