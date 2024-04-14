struct SnakeComponent: Component {
    // Each entity in `occupies` should have a position and RectRenderableComponent
    var occupies: SnakeGameDeque<Entity>
    let direction: SnakeGameDirection

    init(_ occupies: SnakeGameDeque<Entity>, direction: SnakeGameDirection) {
        self.occupies = occupies
        self.direction = direction
    }
}
