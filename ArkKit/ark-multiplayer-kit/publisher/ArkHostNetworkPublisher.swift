class ArkHostNetworkPublisher: ArkNetworkPublisherDelegate {
    // network related dependencies
    weak var networkService: AbstractNetworkService?
    private var peers = [String]()
    private(set) var peerInfoToPlayerIdMap: [String: Int] = [:]

    init(publishTo networkService: AbstractNetworkService,
         playerStateSetUpDelegate: ArkPlayerStateSetupDelegate? = nil) {
        self.networkService = networkService
        self.networkService?.publisher = self

        // Host will always be player 0
        self.peerInfoToPlayerIdMap[networkService.deviceID] = 0
        playerStateSetUpDelegate?.setup(0)
    }

    func publish(ecs: ArkECS) {
        do {
            let encodedECS = try ArkECSDataSerializer.encodeArkECS(ecs: ecs)
            networkService?.sendData(data: encodedECS)
        } catch {
            print("Error encoding or sending ecs function: \(error)")
        }
    }

    func publish(event: any ArkEvent) {
        // Host does not publish events
        // event updates are propagated through ECS
    }

    func onChangeInObservers(manager: ArkNetworkService, connectedDevices: [String]) {
        // registers listeners to publish to
        peers = connectedDevices
        // remove peers from peerInfoToPlayerIdMap
        if let myPeerInfo = networkService?.deviceID {
            let validPeers = Set(peers + [myPeerInfo])
            for peerInfo in peerInfoToPlayerIdMap.keys where !validPeers.contains(peerInfo) {
                peerInfoToPlayerIdMap.removeValue(forKey: peerInfo)
            }
        }
        // if a peer is not in, assign to new playerId
        guard var maxPlayerId = peerInfoToPlayerIdMap.values.compactMap({ $0 }).max() else {
            return
        }

        for peer in peers where peerInfoToPlayerIdMap[peer] == nil {
            peerInfoToPlayerIdMap[peer] = maxPlayerId + 1
            maxPlayerId += 1
        }

        // sendData
        do {
            let encodedPeerToPlayerMapping = try ArkPeerToPlayerIdSerializer.encodeMapping(peerInfoToPlayerIdMap)
            networkService?.sendData(data: encodedPeerToPlayerMapping)
        } catch {
            print("Error encoding or sending peerToPlayerId mapping: \(error)")
        }

    }
}
