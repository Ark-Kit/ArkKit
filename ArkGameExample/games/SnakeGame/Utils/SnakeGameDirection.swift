import Foundation

enum SnakeGameDirection: Codable {
    case north, south, east, west

    static func fromRadians(_ radians: CGFloat) -> SnakeGameDirection {
        let piOverFour = Double.pi / 4

        if piOverFour < radians && radians <= 3 * piOverFour {
            return .east
        } else if 3 * piOverFour < radians && radians <= 5 * piOverFour {
            return .south
        } else if 5 * piOverFour < radians && radians <= 7 * piOverFour {
            return .west
        } else {
            return .north
        }
    }

    var radians: CGFloat {
        if case .north = self {
            return 0
        } else if case .south = self {
            return CGFloat.pi
        } else if case .east = self {
            return CGFloat.pi / 2
        } else {
            return 3 * CGFloat.pi / 2
        }
    }

    var opposite: SnakeGameDirection {
        guard let result = snakeGameOppositeDirection[self] else {
            assertionFailure("Missing value in snakeGameOppositeDirection for \(self)")
            return .north
        }
        return result
    }
}

struct SnakeGameDirectionDelta {
    let dx: Int
    let dy: Int
}

let snakeGameDirectionToDelta: [SnakeGameDirection: SnakeGameDirectionDelta] = [
    .north: SnakeGameDirectionDelta(dx: 0, dy: -1),
    .south: SnakeGameDirectionDelta(dx: 0, dy: 1),
    .east: SnakeGameDirectionDelta(dx: 1, dy: 0),
    .west: SnakeGameDirectionDelta(dx: -1, dy: 0)
]

let snakeGameOppositeDirection: [SnakeGameDirection: SnakeGameDirection] = [
    .north: .south,
    .south: .north,
    .east: .west,
    .west: .east
]
