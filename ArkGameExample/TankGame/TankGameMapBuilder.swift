import Foundation

class TankGameMapBuilder {
    let strategies: [TankGameTerrainStrategy]
    let ecsContext: ArkECSContext
    let zPosition: Double
    let gridSize: Double = 80.0
    let width: Double
    let height: Double

    init(width: Double, height: Double, strategies: [TankGameTerrainStrategy],
         ecsContext: ArkECSContext, zPosition: Double) {
        self.strategies = strategies
        self.ecsContext = ecsContext
        self.zPosition = zPosition
        self.width = width
        self.height = height
    }

    func buildMap(from values: [[Int]]) {
        guard let firstRow = values.first else {
            return }
        let numRows = Double(values.count)
        let numCols = Double(firstRow.count)
        let gridSize = CGSize(width: width / numCols, height: height / numRows)

        for (x, row) in values.enumerated() {
            for (y, value) in row.enumerated() {
                for strategy in strategies {
                    if let imageResourcePath = strategy.imageResourcePath(forValue: value) {
                        let component = BitmapImageRenderableComponent(imageResourcePath: imageResourcePath,
                                                                       width: gridSize.width,
                                                                       height: gridSize.height)
                            .shouldRerender { _, _ in false }
                            .center(CGPoint(x: Double(x) * gridSize.width + gridSize.width / 2,
                                            y: Double(y) * gridSize.height + gridSize.height / 2))
                            .zPosition(zPosition)
                            .scaleAspectFill()
                            .clipToBounds()
                        ecsContext.createEntity(with: [component])
                        break
                    }
                }
            }
        }
    }
}

protocol TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String?
}

class TankGameMap1Strategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String? {
        value == 1 ? "map_1" : nil
    }
}

class TankGameMap2Strategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String? {
        value == 2 ? "map_2" : nil
    }
}

class TankGameMap3Strategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String? {
        value == 3 ? "map_3" : nil
    }
}

class TankGameTile1AStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String? {
        value == 4 ? "Ground_Tile_01_A" : nil
    }
}

class TankGameTile1BStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String? {
        value == 5 ? "Ground_Tile_01_B" : nil
    }
}

class TankGameTile1CStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String? {
        value == 6 ? "Ground_Tile_01_C" : nil
    }
}

class TankGameTile2AStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String? {
        value == 7 ? "Ground_Tile_02_A" : nil
    }
}

class TankGameTile2BStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String? {
        value == 8 ? "Ground_Tile_02_B" : nil
    }
}

class TankGameTile2CStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> String? {
        value == 9 ? "Ground_Tile_02_C" : nil
    }
}
