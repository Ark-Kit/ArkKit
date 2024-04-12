import Foundation

struct SnakeGrid {
    let boxSideLength: Double
    let gridHeight: Double
    let gridWidth: Double

    func toActualPosition(_ gridPosition: SnakeGridPosition) -> CGPoint {
        let x = gridPosition.x * boxSideLength
        let y = gridPosition.y * boxSideLength

        return CGPoint(x: x, y: y)
    }
}
