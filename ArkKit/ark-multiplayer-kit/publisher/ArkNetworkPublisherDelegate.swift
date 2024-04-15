protocol ArkNetworkPublisherDelegate: AnyObject {
    func onChangeInObservers(manager: ArkNetworkService, connectedDevices: [String])
    func publish(ecs: ArkECS)
    func publish(event: any ArkEvent)
}
