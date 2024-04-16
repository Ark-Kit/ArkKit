class ArkSetUpIfHostStrategy<View, ExternalResources: ArkExternalResources>: ArkSetUpStrategy {
    weak var ark: Ark<View, ExternalResources>?

    init(ark: Ark<View, ExternalResources>? = nil) {
        self.ark = ark
    }

    func setUp() {
        let startingSetUpStrategy = ArkSetUpWithoutNetwork(ark: ark)
        startingSetUpStrategy.setUp()
        guard let ark = ark,
              let networkPlayableInfo = ark.blueprint.networkPlayableInfo,
              networkPlayableInfo.role == .host else {
            return
        }
        let networkService = ArkNetworkService(serviceName: networkPlayableInfo.roomName)
        ark.networkService = networkService
        let publisher = ArkHostNetworkPublisher(publishTo: networkService, playerStateSetUpDelegate: self)
        ark.arkState.arkECS.addSystem(ArkHostSystem(publisher: publisher))
        ark.hostSubscriber = ArkHostNetworkSubscriber(subscribeTo: networkService)
        ark.hostSubscriber?.localState = ark.arkState
    }
}

extension ArkSetUpIfHostStrategy: ArkPlayerStateSetupDelegate {
    func setup(_ playerId: Int) {
        let playerSetUpCallbacks = ark?.blueprint.playerSpecificSetupFunctions
        guard let specificPlayerSetUp = playerSetUpCallbacks?[playerId],
              let ark = ark else {
            return
        }
        ark.arkState.setup(specificPlayerSetUp, with: ark.setupContext)
    }
}
