//
//  ArkMultiplayerManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import MultipeerConnectivity

class ArkMultiplayerManager: ArkNetworkDelegate {
    private var networkService: ArkNetworkService
    var multiplayerEventManager: ArkMultiplayerEventManager?

    init(serviceName: String) {
        self.networkService = ArkNetworkService(serviceType: serviceName)
        self.networkService.delegate = self
    }

    func sendEvent(event: any ArkEvent) {
        do {
            let eventData = try JSONEncoder().encode(event)
            let eventName = String(describing: type(of: event))
            let wrapper = DataWrapper(type: .event, name: eventName, payload: eventData)
            let wrappedData = try JSONEncoder().encode(wrapper)

            networkService.sendData(data: wrappedData)
        } catch {
            print("Error encoding or sending event: \(error)")
        }
    }

    func gameDataReceived(manager: ArkNetworkService, gameData: Data) {
        do {
            let wrappedData = try JSONDecoder().decode(DataWrapper.self, from: gameData)

            if wrappedData.type == .event {
                if let event = try multiplayerEventManager?.eventRegistry.decode(from: wrappedData.payload,
                                                                                 typeName: wrappedData.name) {
                    processEvent(event: event)
                }
            }

        } catch {
            print("Error decoding received data: \(error)")
        }
    }

    private func processEvent(event: any ArkEvent) {
        print("Received event: \(event)")
        multiplayerEventManager?.emitWithoutBroadcast(event)
    }

    func connectedDevicesChanged(manager: ArkNetworkService, connectedDevices: [String]) {
    }

}
