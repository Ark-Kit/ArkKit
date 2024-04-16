enum TankGameImage: String {
    // Background map
    case map_1
    case map_2
    case map_3

    // Background map tiles
    case Ground_Tile_01_A
    case Ground_Tile_01_B
    case Ground_Tile_01_C
    case Ground_Tile_02_A
    case Ground_Tile_02_B
    case Ground_Tile_02_C

    // Interactable environment objects
    case lake
    case stones_1
    case stones_2 = "barrel_01"
    case stones_3
    case stones_4 = "barrel_02"
    case stones_5
    case stones_6 = "well"

    // Tank
    case ball = "medium_shell"
    case tank_1
    case tank_2
    case tank_3
    case tank_4
    case tire_track_1
    case tire_track_2

    // Powerups
    case healthPack = "health-red"
}
