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

    init() {
        self.networkService = ArkNetworkService()
        self.networkService.delegate = self
    }

    func sendEvent(event: any ArkEvent) {
        guard let event = event as? any SendableEvent else {
            return
        }

        do {
            let eventData = try JSONEncoder().encode(event)
            let wrapper = DataWrapper(type: .event, payload: eventData)
            let wrappedData = try JSONEncoder().encode(wrapper)

            networkService.sendGameData(data: wrappedData)
        } catch {
            print("Error encoding or sending event: \(error)")
        }
    }

    func gameDataReceived(manager: ArkNetworkService, gameData: Data) {
        do {
            let wrapper = try JSONDecoder().decode(DataWrapper.self, from: gameData)

//            switch wrapper.type {
//            case .event:
//                let event = try JSONDecoder().decode(SendableEvent.self, from: wrapper.payload)
//                // Handle the event
//            case .state:
//                let state = try JSONDecoder().decode(SendableEvent.self, from: wrapper.payload)
//                // Handle the state
//            }
        } catch {
            print("Error decoding received data: \(error)")
        }
    }

    func processEvent(event: any ArkEvent) {
        multiplayerEventManager?.emit(event)
    }

    func connectedDevicesChanged(manager: ArkNetworkService, connectedDevices: [String]) {
    }

}
