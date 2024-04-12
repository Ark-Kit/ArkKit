import Foundation

struct SnakeGrid {
    let boxSideLength: Int
    let gridHeight: Double
    let gridWidth: Double

    var rows: Int {
        Int((gridHeight / Double(boxSideLength)).rounded(.down))
    }

    var cols: Int {
        Int((gridWidth / Double(boxSideLength)).rounded(.down))
    }

    func toActualPosition(_ gridPosition: SnakeGridPosition) -> CGPoint {
        let x = gridPosition.x * boxSideLength
        let y = gridPosition.y * boxSideLength

        return CGPoint(x: x, y: y)
    }

    func getRandomEmptyBox(_ occupiedGridPositions: [SnakeGridPosition]) -> SnakeGridPosition {
        let set = Set(occupiedGridPositions)
        let totalBoxes = rows * cols

        while set.count < totalBoxes {
            let row = Int.random(in: 0..<rows)
            let col = Int.random(in: 0..<cols)
            let gridPosition = SnakeGridPosition(x: row, y: col)
            if !set.contains(gridPosition) {
                return gridPosition
            }
        }

        return SnakeGridPosition(x: 0, y: 0)
    }
}
