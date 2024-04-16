class ArkParticipantNetworkPublisher: ArkNetworkPublisherDelegate {
    // network related dependencies
    weak var networkService: AbstractNetworkService?
    private var peers = [String]()

    init(publishTo networkService: AbstractNetworkService) {
        self.networkService = networkService
        self.networkService?.publisher = self
    }

    func publish(ecs: ArkECS) {
        // Participant does not publish ECS
    }

    func publish(event: any ArkEvent) {
        do {
            if let encodedEvent = try ArkEventDataSerializer.encodeEvent(event) {
                networkService?.sendData(data: encodedEvent)
            }
        } catch {
            print("Error encoding or sending event: \(error)")
        }
    }

    func onChangeInObservers(manager: ArkNetworkService, connectedDevices: [String]) {
        // registers listeners to publish to
        peers = connectedDevices
    }
}
