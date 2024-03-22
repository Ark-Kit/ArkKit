import Foundation

struct TankGameEntityCreator {

    @discardableResult
    static func createTank(at position: CGPoint, rotation: CGFloat,
                           tankIndex: Int, in ecsContext: ArkECSContext) -> Entity {
        let tankEntity = ecsContext.createEntity(with: [
            BitmapImageCanvasComponent(imageResourcePath: "tank_\(tankIndex)", center: position, width: 80, height: 100)
                .scaleAspectFill(),
            PositionComponent(position: position),
            RotationComponent(angleInRadians: rotation),
            // TODO: Set up physics
            PhysicsComponent(shape: .rectangle, size: CGSize(width: 80, height: 100), allowsRotation: true,
                             categoryBitMask: 0, collisionBitMask: 0, contactTestBitMask: 0)
        ])
        return tankEntity
    }

    static func createJoyStick(center: CGPoint, tankEntity: Entity, in ecsContext: ArkECSContext,
                               eventContext: ArkEventContext) {
        ecsContext.createEntity(with: [
            JoystickCanvasComponent(radius: 40, areValuesEqual: { _, _ in true })
                .center(center)
                .onPanChange { angle, mag in
                    let tankMoveEventData = TankMoveEventData(name: "TankMoveEvent", tankEntity: tankEntity,
                                                              angle: angle, magnitude: mag)
                    var tankMoveEvent: any ArkEvent = TankMoveEvent(eventData: tankMoveEventData)
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

    static func createShootButton(at position: CGPoint, tankEntity: Entity, in ecsContext: ArkECSContext,
                                  eventContext: ArkEventContext) {
        ecsContext.createEntity(with: [
            ButtonCanvasComponent(width: 50, height: 50,
                                  areValuesEqual: { _, _ in true })
            .center(position)
            .onTap {
                let tankShootEventData = TankShootEventData(name: "TankShootEvent", tankEntity: tankEntity)
                var tankShootEvent: any ArkEvent = TankShootEvent(eventData: tankShootEventData)
                eventContext.emit(&tankShootEvent)
            }
        ])
    }

    static func createBall(position: CGPoint, velocity: CGVector, angle: CGFloat, in ecsContext: ArkECSContext) {
        ecsContext.createEntity(with: [
            BitmapImageCanvasComponent(imageResourcePath: "ball", center: position, width: 20, height: 20)
                .scaleAspectFill(),
            PositionComponent(position: position),
            RotationComponent(angleInRadians: angle),
            // TODO: Set up physics
            PhysicsComponent(shape: .circle, radius: 20, velocity: velocity, allowsRotation: true,
                             categoryBitMask: 0, collisionBitMask: 0, contactTestBitMask: 0)

        ])
    }

    static func addBackground(width: Double, height: Double, in ecsContext: ArkECSContext) {
        let gridSize: Double = 20.0
        let gridWidth = Int(width / gridSize)
        let gridHeight = Int(height / gridSize)

        for x in 0...gridWidth {
            for y in 0...gridHeight {
                ecsContext.createEntity(with: [
                    BitmapImageCanvasComponent(imageResourcePath: "map_1",
                                               center: CGPoint(x: Double(x) * gridSize + gridSize / 2,
                                                               y: Double(y) * gridSize + gridSize / 2),
                                               width: gridSize, height: gridSize)
                        .scaleAspectFill()
                ])

            }
        }

    }
}
