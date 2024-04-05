//
//  ArkMultiplayerManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import MultipeerConnectivity

enum PeerRole {
    case master
    case slave
}

class ArkMultiplayerManager: ArkNetworkDelegate {
    private var networkService: ArkNetworkProtocol
    var multiplayerEventManager: ArkMultiplayerEventManager?
    var arkMultiplayerECS: ArkMultiplayerECS?
    private var peers = [String]()
    private var masterPeer: String?
    private var role: PeerRole = .master

    init(serviceName: String) {
        self.networkService = ArkNetworkService(serviceName: serviceName)
        self.networkService.delegate = self
    }

    func gameDataReceived(manager: ArkNetworkService, gameData: Data) {
        print("data received")
        do {
            let wrappedData = try JSONDecoder().decode(DataWrapper.self, from: gameData)

            if wrappedData.type == .event,
               let event = try ArkEventRegistry.shared.decode(from: wrappedData.payload,
                                                              typeName: wrappedData.name) {
                processEvent(event: event)
            }
            
            if wrappedData.type == .ecsFunction {
                
            }
            
        } catch {
            print("Error decoding received data: \(error)")
        }
    }

    private func processEvent(event: any ArkEvent) {
        multiplayerEventManager?.emitWithoutBroadcast(event)
    }

    func connectedDevicesChanged(manager: ArkNetworkService, connectedDevices: [String]) {
        peers = connectedDevices
        updateRoles()
    }
    
    private func updateRoles() {
        let sortedPeers = (peers + [networkService.deviceID]).sorted()
        masterPeer = sortedPeers.first

        role = masterPeer == networkService.deviceID ? .master : .slave
        print("Updated role: \(role)")
    }

}

extension ArkMultiplayerManager: ArkMultiplayerEventManagerDelegate {
    func shouldSendEvent<Event: ArkEvent>(_ event: Event) {
        sendEvent(event: event)
    }
    
    private func sendEvent(event: any ArkEvent) {
        do {
            if let encodedEvent = try ArkDataSerializer.encodeEvent(event) {
                networkService.sendData(data: encodedEvent)
            }
        } catch {
            print("Error encoding or sending event: \(error)")
        }
    }
}

extension ArkMultiplayerManager: ArkMultiplayerECSDelegate {
    var isModificationEnabled: Bool {
        self.role == .master
    }
    
    private func sendEcsFunction() {
        
    }
    
    func didCreateEntity(_ entity: Entity) {
        guard self.role == .master else {
            return
        }
        
        // Send create entity function to slave
    }
    
    
    func didRemoveEntity(_ entity: Entity) {
        guard self.role == .master else {
            return
        }
        
        // Send remove entity function to slave
    }
    func didRemoveComponent<T: Component>(_ componentType: T.Type, from entity: Entity) {
        guard self.role == .master else {
            return
        }
        
        // Send remove component function to slave
    }
    
    func didUpsertComponent<T: Component>(_ component: T, to entity: Entity) {
        guard self.role == .master else {
            return
        }
        
        // Send upsert component function to slave
    }
    
    func didCreateEntity(_ entity: Entity, with components: [Component]) {
        guard self.role == .master else {
            return
        }
        
        // Send create entity with components function to slave
    }
    
}
