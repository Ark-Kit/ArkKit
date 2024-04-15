struct ArkNetworkPlayableInfo {
    let roomName: String
    let numberOfPlayers: Int
    let role: ArkPeerRole?

    init(roomName: String, numberOfPlayers: Int, role: ArkPeerRole? = nil) {
        self.roomName = roomName
        self.numberOfPlayers = numberOfPlayers
        self.role = role
    }
}
