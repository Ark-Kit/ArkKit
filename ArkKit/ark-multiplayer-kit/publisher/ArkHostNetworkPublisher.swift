class ArkHostNetworkPublisher: ArkNetworkPublisherDelegate {
    // network related dependencies
    var networkService: AbstractNetworkService
    private var peers = [String]()

    init(publishTo networkService: AbstractNetworkService) {
        self.networkService = networkService
        self.networkService.publisher = self
    }

    func publish(ecs: ArkECS) {
        do {
            let encodedECS = try ArkECSDataSerializer.encodeArkECS(ecs: ecs)
            networkService.sendData(data: encodedECS)
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
    }
}
