enum SnakeGameDirection {
    case north, south, east, west
}

struct SnakeGameDirectionDelta {
    let dx: Double
    let dy: Double
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
