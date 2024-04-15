struct ArkSetUpIfHostStrategy<View, ExternalResources: ArkExternalResources>: ArkSetUpStrategy {
    weak var ark: Ark<View, ExternalResources>?

    func setUp() {
        let startingSetUpStrategy = ArkSetUpWithoutNetwork(ark: ark)
        startingSetUpStrategy.setUp()

        guard let ark = ark,
              let networkPlayableInfo = ark.blueprint.networkPlayableInfo,
              networkPlayableInfo.role == .host else {
            return
        }
        let networkService = ArkNetworkService(serviceName: networkPlayableInfo.roomName)
        let publisher = ArkHostNetworkPublisher(publishTo: networkService)
        ark.arkState.arkECS.addSystem(ArkHostSystem(publisher: publisher))

        ark.hostSubscriber = ArkHostNetworkSubscriber(subscribeTo: networkService)
        ark.hostSubscriber?.localState = ark.arkState
    }
}
