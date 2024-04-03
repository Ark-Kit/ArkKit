//
//  ArkMultiplayerManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import MultipeerConnectivity

class ArkMultiplayerManager: ArkNetworkDelegate {
    private var networkService: ArkNetworkProtocol
    var multiplayerEventManager: ArkMultiplayerEventManager?

    init(serviceName: String) {
        self.networkService = ArkNetworkService(serviceName: serviceName)
        self.networkService.delegate = self
    }

    func sendEvent(event: any ArkEvent) {
        do {
            if let encodedEvent = try ArkDataSerializer.encodeEvent(event) {
                networkService.sendData(data: encodedEvent)
            }
        } catch {
            print("Error encoding or sending event: \(error)")
        }
    }

    func gameDataReceived(manager: ArkNetworkService, gameData: Data) {
        print("data received")
        do {
            let wrappedData = try JSONDecoder().decode(DataWrapper.self, from: gameData)

            if wrappedData.type == .event {
                if let event = try ArkEventRegistry.shared.decode(from: wrappedData.payload,
                                                                  typeName: wrappedData.name) {
                    processEvent(event: event)
                }
            }
        } catch {
            print("Error decoding received data: \(error)")
        }
    }

    private func processEvent(event: any ArkEvent) {
        multiplayerEventManager?.emitWithoutBroadcast(event)
    }

    func connectedDevicesChanged(manager: ArkNetworkService, connectedDevices: [String]) {
    }

}

extension ArkMultiplayerManager: ArkMultiplayerManagerDelegate {
    func shouldSendEvent<Event: ArkEvent>(_ event: Event) {
        sendEvent(event: event)
    }
}
