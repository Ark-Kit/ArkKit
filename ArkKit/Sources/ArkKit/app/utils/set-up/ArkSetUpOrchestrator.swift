struct ArkSetUpOrchestrator<View, ExternalResources: ArkExternalResources> {
    weak var ark: Ark<View, ExternalResources>?

    func executeSetUp() {
        guard let networkPlayableInfo = ark?.blueprint.networkPlayableInfo else {
            // no network playable set
            let noNetworkSetUpStrategy = ArkSetUpWithoutNetworkStrategy(ark: ark)
            noNetworkSetUpStrategy.setUp()
            return
        }
        if networkPlayableInfo.role == .host {
            ArkSetUpIfHostStrategy(ark: ark).setUp()
        } else {
            ArkSetUpIfParticipantStrategy(ark: ark).setUp()
        }
    }
}
