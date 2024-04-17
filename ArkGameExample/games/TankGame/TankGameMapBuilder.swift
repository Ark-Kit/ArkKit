import Foundation

class TankGameMapBuilder {
    let ecsContext: ArkECSContext
    let zPosition: Double
    let gridSize: Double = 80.0
    let width: Double
    let height: Double
    var strategies: [TankGameTerrainStrategy]

    init(width: Double, height: Double,
         ecsContext: ArkECSContext, zPosition: Double) {
        self.ecsContext = ecsContext
        self.zPosition = zPosition
        self.width = width
        self.height = height
        self.strategies = []
        self.setup()
    }

    func setup() {
        self.register(TankGameMap1Strategy())
        self.register(TankGameMap2Strategy())
        self.register(TankGameMap3Strategy())
        self.register(TankGameTile1AStrategy())
        self.register(TankGameTile1BStrategy())
        self.register(TankGameTile1CStrategy())
        self.register(TankGameTile2AStrategy())
        self.register(TankGameTile2BStrategy())
        self.register(TankGameTile2CStrategy())
}

    func register(_ strategy: TankGameTerrainStrategy) {
        strategies.append(strategy)
    }

    func createTileGrid(rows: Int, cols: Int) -> [[Int]] {
        let patterns = [[4, 7], [5, 8], [6, 9]]
        return (0..<rows).map { _ in
            (0..<cols).map { col in
                let patternIndex = (col / (cols / patterns.count)) % patterns.count
                return patterns[0][0]
            }
        }
    }

    func buildMap(rows: Int, cols: Int) {
        let array = createTileGrid(rows: rows, cols: cols)
        buildMap(from: array)
    }

    func buildMap(from values: [[Int]]) {
        guard let firstRow = values.first else {
            return }
        let numRows = Double(values.count)
        let numCols = Double(firstRow.count)
        let gridSize = CGSize(width: width / numCols, height: height / numRows)

        for (y, row) in values.enumerated() {
            for (x, value) in row.enumerated() {
                for strategy in strategies {
                    if let imageResourcePath = strategy.imageResourcePath(forValue: value) {
                        let component = BitmapImageRenderableComponent(arkImageResourcePath: imageResourcePath,
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
    func imageResourcePath(forValue value: Int) -> TankGameImage?
}

class TankGameMap1Strategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> TankGameImage? {
        value == 1 ? .map_1 : nil
    }
}

class TankGameMap2Strategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> TankGameImage? {
        value == 2 ? .map_2 : nil
    }
}

class TankGameMap3Strategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> TankGameImage? {
        value == 3 ? .map_3 : nil
    }
}

class TankGameTile1AStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> TankGameImage? {
        value == 4 ? .Ground_Tile_01_A : nil
    }
}

class TankGameTile1BStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> TankGameImage? {
        value == 5 ? .Ground_Tile_01_B : nil
    }
}

class TankGameTile1CStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> TankGameImage? {
        value == 6 ? .Ground_Tile_01_C : nil
    }
}

class TankGameTile2AStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> TankGameImage? {
        value == 7 ? .Ground_Tile_02_A : nil
    }
}

class TankGameTile2BStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> TankGameImage? {
        value == 8 ? .Ground_Tile_02_B : nil
    }
}

class TankGameTile2CStrategy: TankGameTerrainStrategy {
    func imageResourcePath(forValue value: Int) -> TankGameImage? {
        value == 9 ? .Ground_Tile_02_C : nil
    }
}
