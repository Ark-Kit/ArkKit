struct SnakeGridPosition {
    let x: Double
    let y: Double

    func applyDelta(_ direction: SnakeGameDirection) -> SnakeGridPosition {
        guard let delta = snakeGameDirectionToDelta[direction] else {
            assertionFailure("Delta mapping missing!")
            return self
        }

        return SnakeGridPosition(x: x + delta.dx, y: y + delta.dy)
    }
}
