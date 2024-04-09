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

class ArkMultiplayerManager: ArkNetworkDelegate, ArkMultiplayerContext {
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

    var playerNumber: Int {
        let sortedPeers = (peers + [networkService.deviceID]).sorted()
        if let deviceIndex = sortedPeers.firstIndex(of: networkService.deviceID) {
            return deviceIndex + 1
        } else {
            return 0
        }
    }

    var serviceName: String {
        get {
            networkService.serviceName
        }
        set {
            self.networkService = ArkNetworkService(serviceName: newValue)
            self.networkService.delegate = self
        }
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

            if wrappedData.type == .ecsFunction, let arkMultiplayerECS = arkMultiplayerECS {
                try ArkECSSerializer.decodeECSFunction(data: wrappedData.payload,
                                                       name: wrappedData.name,
                                                       ecs: arkMultiplayerECS.arkECS)
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
    var isBroadcastEvent: Bool {
        self.role == .slave
    }

    func shouldSendEvent<Event: ArkEvent>(_ event: Event) {
        sendEvent(event: event)
    }

    private func sendEvent(event: any ArkEvent) {
        do {
            if let encodedEvent = try ArkDataSerializer.encodeEvent(event),
               let target = masterPeer {
                networkService.sendData(encodedEvent, to: target)
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

    private func sendEcsFunction(function: String, entity: Entity, component: Component? = nil,
                                 components: [Component]? = nil) {

        do {
            if let encodedECSFunction = try ArkECSSerializer.encodeECSFunction(action: function, entity: entity,
                                                                               component: component,
                                                                               components: components) {
                networkService.sendData(data: encodedECSFunction)
            }
        } catch {
            print("Error encoding or sending ecs function: \(error)")
        }
    }

    func didCreateEntity(_ entity: Entity) {
        guard self.role == .master else {
            return
        }
        sendEcsFunction(function: "createEntity", entity: entity)
    }

    func didRemoveEntity(_ entity: Entity) {
        guard self.role == .master else {
            return
        }
        sendEcsFunction(function: "removeEntity", entity: entity)
    }

    func didUpsertComponent<T: Component>(_ component: T, to entity: Entity) {
        guard self.role == .master else {
            return
        }
        sendEcsFunction(function: "upsertComponent", entity: entity, component: component)
    }

    func didCreateEntity(_ entity: Entity, with components: [Component]) {
        guard self.role == .master else {
            return
        }
        sendEcsFunction(function: "createEntity", entity: entity, components: components)
    }

}
