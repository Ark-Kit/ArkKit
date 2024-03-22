import Foundation

class TankGameTerrainObjectBuilder {
    var strategies: [TankGameTerrainObjectStrategy]
    var ecsContext: ArkECSContext
    
    init(strategies: [TankGameTerrainObjectStrategy], ecsContext: ArkECSContext) {
        self.strategies = strategies
        self.ecsContext = ecsContext
    }
    
    func buildObjects(from specifications: [(type: Int, location: CGPoint, size: CGSize)]) {
        for spec in specifications {
            for strategy in strategies where strategy.canHandleType(spec.type) {
                strategy.createObject(type: spec.type, location: spec.location, size: spec.size, in: ecsContext)
                break
            }
        }
    }
}

protocol TankGameTerrainObjectStrategy {
    func canHandleType(_ type: Int) -> Bool
    func createObject(type: Int, location: CGPoint, size: CGSize, in ecsContext: ArkECSContext)
}

class TankGameLakeStrategy: TankGameTerrainObjectStrategy {
    func canHandleType(_ type: Int) -> Bool {
        return type == 0
    }
    
    func createObject(type: Int, location: CGPoint, size: CGSize, in ecsContext: ArkECSContext) {
        ecsContext.createEntity(with: [
            BitmapImageCanvasComponent(imageResourcePath: "lake",
                                       width: size.width, height: size.height)
            .center(location)
        ])
    }
}

class TankGameStoneStrategy: TankGameTerrainObjectStrategy {
    func canHandleType(_ type: Int) -> Bool {
        return type >= 1 && type <= 6
    }
    func createObject(type: Int, location: CGPoint, size: CGSize, in ecsContext: ArkECSContext) {
        let imageResourcePath = "stones_\(type)"
        
        ecsContext.createEntity(with: [
            BitmapImageCanvasComponent(imageResourcePath: imageResourcePath,
                                       width: size.width, height: size.height)
            .center(location)
        ])
    }
}
