import Foundation

struct TankPropSpecification {
    var type: Int
    var location: CGPoint
    var size: CGSize
    var zPos: Double
}

class TankGameTerrainObjectBuilder {
    var strategies: [TankGameTerrainObjectStrategy]
    var ecsContext: ArkECSContext

    init(ecsContext: ArkECSContext) {
        self.strategies = []
        self.ecsContext = ecsContext
        self.setup()
    }

    func setup() {
        self.register(TankGameLakeStrategy())
        self.register(TankGameStoneStrategy())
        self.register(TankGameHealthPackStrategy())
    }

    func register(_ strategy: TankGameTerrainObjectStrategy) {
        strategies.append(strategy)
    }

    func buildObjects(from specifications: [TankPropSpecification]) {
        for spec in specifications {
            for strategy in strategies where strategy.canHandleType(spec.type) {
                strategy.createObject(type: spec.type,
                                      location: spec.location,
                                      size: spec.size,
                                      zPos: spec.zPos,
                                      in: ecsContext)
                break
            }
        }
    }
}

protocol TankGameTerrainObjectStrategy {
    func canHandleType(_ type: Int) -> Bool
    @discardableResult
    func createObject(type: Int, location: CGPoint, size: CGSize,
                      zPos: Double, in ecsContext: ArkECSContext) -> Entity
}

class TankGameLakeStrategy: TankGameTerrainObjectStrategy {
    func canHandleType(_ type: Int) -> Bool {
        type == 0
    }

    @discardableResult
    func createObject(type: Int, location: CGPoint, size: CGSize,
                      zPos: Double, in ecsContext: ArkECSContext) -> Entity {
        ecsContext.createEntity(with: [
            BitmapImageRenderableComponent(arkImageResourcePath: TankGameImage.lake,
                                                           width: size.width, height: size.height)
            .zPosition(zPos)
            .center(location)
            .scaleToFill(),
            PositionComponent(position: location),
            RotationComponent(angleInRadians: 0),
            PhysicsComponent(shape: .rectangle, size: size, isDynamic: false,
                             categoryBitMask: TankGamePhysicsCategory.water,
                             collisionBitMask: TankGamePhysicsCategory.none,
                             contactTestBitMask: TankGamePhysicsCategory.tank)
        ])
    }
}

class TankGameStoneStrategy: TankGameTerrainObjectStrategy {
    func canHandleType(_ type: Int) -> Bool {
        type >= 1 && type <= 6
    }

    private let stoneTypeToImageAsset: [Int: TankGameImage] = [
        1: .stones_1,
        2: .stones_2,
        3: .stones_3,
        4: .stones_4,
        5: .stones_5,
        6: .stones_6
    ]

    @discardableResult
    func createObject(type: Int, location: CGPoint, size: CGSize,
                      zPos: Double, in ecsContext: ArkECSContext) -> Entity {
        ecsContext.createEntity(with: [
            BitmapImageRenderableComponent(arkImageResourcePath: stoneTypeToImageAsset[type] ?? .stones_1,
                                           width: size.width, height: size.height)
            .zPosition(zPos)
            .center(location),
            PositionComponent(position: location),
            RotationComponent(angleInRadians: 0),
            PhysicsComponent(shape: .circle, radius: size.width / 2, mass: 1, isDynamic: false, allowsRotation: false,
                             categoryBitMask: TankGamePhysicsCategory.rock,
                             collisionBitMask: TankGamePhysicsCategory.ball | TankGamePhysicsCategory.tank,
                             contactTestBitMask: TankGamePhysicsCategory.tank | TankGamePhysicsCategory.ball)
        ])
    }
}

class TankGameHealthPackStrategy: TankGameTerrainObjectStrategy {
    func canHandleType(_ type: Int) -> Bool {
        type == 7
    }

    @discardableResult
    func createObject(type: Int, location: CGPoint, size: CGSize,
                      zPos: Double, in ecsContext: ArkECSContext) -> Entity {
        ecsContext.createEntity(with: [
            TankHealthPackGeneratorComponent(size: size, zPosition: zPos),
            PositionComponent(position: location),
            RotationComponent(angleInRadians: 0)
        ])
    }
}
