import Foundation

class ArkHostNetworkSubscriber: ArkNetworkSubscriberDelegate {
    // network related dependencies
    weak var networkService: AbstractNetworkService?

    // inject dependency
    weak var localState: ArkState?

    init(subscribeTo networkService: AbstractNetworkService) {
        self.networkService = networkService
        self.networkService?.subscriber = self
    }

    func onListen(_ data: Data) {
        do {
            let wrappedData = try JSONDecoder().decode(DataWrapper.self, from: data)

            if wrappedData.type == .event,
               let event = try ArkEventRegistry.shared.decode(from: wrappedData.payload,
                                                              typeName: wrappedData.name) {
                processEvent(event: event)
            }

            // host does not listen to ecs updates
        } catch {
            print("Error decoding received data: \(error)")
        }
    }

    private func processEvent(event: any ArkEvent) {
        localState?.eventManager.emit(event)
    }
}
