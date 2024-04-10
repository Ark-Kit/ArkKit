enum TankGameSounds: Int {
    case shoot, move
}

let tankGameSoundMapping: [TankGameSounds: any Sound] = [
    .shoot: TankShootSound()
]
