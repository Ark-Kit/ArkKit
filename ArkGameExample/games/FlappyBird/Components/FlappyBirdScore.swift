struct FlappyBirdScore: Component {
    var scores: [Int: Int]

    mutating func setScore(_ score: Int, forId characterId: Int) {
        scores[characterId] = score
    }
}
