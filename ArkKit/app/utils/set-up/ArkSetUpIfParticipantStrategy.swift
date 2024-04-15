class ArkSetUpIfParticipantStrategy<View, ExternalResources: ArkExternalResources>: ArkSetUpStrategy {
    weak var ark: Ark<View, ExternalResources>?

    init(ark: Ark<View, ExternalResources>? = nil) {
        self.ark = ark
    }

    func setUp() {
        guard let ark = ark,
              let networkPlayableInfo = ark.blueprint.networkPlayableInfo,
              networkPlayableInfo.role == .participant else {
            return
        }
        setupDefaultListeners()
        setupMultiplayerGameLoop()
        setup(ark.blueprint.soundMapping)

        let networkService = ArkNetworkService(serviceName: networkPlayableInfo.roomName)
        ark.participantSubscriber = ArkParticipantNetworkSubscriber(subscribeTo: networkService)
        ark.participantSubscriber?.localState = ark.arkState
        ark.participantSubscriber?.localGameLoop = ark.gameLoop
        ark.participantSubscriber?.playerStateSetUpDelegate = self

        let participantPublisher = ArkParticipantNetworkPublisher(publishTo: networkService)
        ark.arkState.eventManager.networkPublisherDelegate = participantPublisher
    }
}

extension ArkSetUpIfParticipantStrategy: ArkPlayerStateSetupDelegate {
    func setup(_ playerId: Int) {
        let playerSetUpCallbacks = ark?.blueprint.playerSpecificSetupFunctions
        guard playerId < playerSetUpCallbacks?.count ?? 0,
              let specificPlayerSetUp = playerSetUpCallbacks?[playerId],
              let displayContext = ark?.displayContext else {
            return
        }
        ark?.arkState.setup(specificPlayerSetUp, displayContext: displayContext)
    }
}
