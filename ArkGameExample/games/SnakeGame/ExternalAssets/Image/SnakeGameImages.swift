enum SnakeGameImages: String {
    case map = "map_3"
    case apple = "apple_alt"
    case snake_1_head = "snake_green_head"
    case snake_1_body = "snake_green_blob"
    case snake_1_dead = "snake_green_xx"
    case snake_2_head = "snake_yellow_head"
    case snake_2_Body = "snake_yellow_blob"
    case snake_2_dead = "snake_yellow_xx"

    static func snakeHead(_ playerId: Int) -> SnakeGameImages {
        if playerId == 1 {
            return .snake_1_head
        } else {
            return .snake_2_head
        }
    }

    static func snakeBody(_ playerId: Int) -> SnakeGameImages {
        if playerId == 1 {
            return .snake_1_body
        } else {
            return .snake_2_Body
        }
    }

    static func snakeDead(_ playerId: Int) -> SnakeGameImages {
        if playerId == 1 {
            return .snake_1_dead
        } else {
            return .snake_2_dead
        }
    }
}
