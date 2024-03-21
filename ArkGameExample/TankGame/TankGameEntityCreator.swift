import Foundation

struct TankGameEntityCreator {

    @discardableResult
    static func createTank(at position: CGPoint, tankIndex: Int, in ecsContext: ArkECSContext) -> Entity {
        let tankEntity = ecsContext.createEntity(with: [
            BitmapImageCanvasComponent(imageResourcePath: "tank_\(tankIndex)", center: position, width: 80, height: 100)
                .scaleAspectFill()
        ])
        return tankEntity
    }

    static func createJoyStick(center: CGPoint, tankEntity: Entity, in ecsContext: ArkECSContext) {
        ecsContext.createEntity(with: [
            JoystickCanvasComponent(center: center, radius: 40,
                                    areValuesEqual: { _, _ in true })
                .onPanChange { angle, mag in print("change", angle, mag) }
                .onPanStart { angle, mag in print("start", angle, mag) }
                .onPanEnd { angle, mag in print("end", angle, mag) }
        ])
    }
}
