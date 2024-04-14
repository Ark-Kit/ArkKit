import MultipeerConnectivity

enum PeerRole {
    case host
    case participant
}

class ArkMultiplayerManager: ArkNetworkDelegate, ArkMultiplayerContext {
    private var networkService: ArkNetworkProtocol
    var multiplayerEventManager: ArkMultiplayerEventManager?
    var arkMultiplayerECS: ArkMultiplayerECS?
    private var participants = [String]()
    private var host: String?
    private var role: PeerRole = .host

    init(serviceName: String) {
        self.networkService = ArkNetworkService(serviceName: serviceName)
        self.networkService.delegate = self
    }

    var playerNumber: Int {
        let sortedPeers = (participants + [networkService.deviceID]).sorted()
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
        participants = connectedDevices
        updateRoles()
    }

    private func updateRoles() {
        let sortedPeers = (participants + [networkService.deviceID]).sorted()
        host = sortedPeers.first

        role = host == networkService.deviceID ? .host : .participant
        print("Updated role: \(role)")
    }
}

extension ArkMultiplayerManager: ArkMultiplayerEventManagerDelegate {
    var isBroadcastEvent: Bool {
        self.role == .participant
    }

    func shouldSendEvent<Event: ArkEvent>(_ event: Event) {
        sendEvent(event: event)
    }

    private func sendEvent(event: any ArkEvent) {
        do {
            if let encodedEvent = try ArkDataSerializer.encodeEvent(event),
               let target = host {
                networkService.sendData(encodedEvent, to: target)
            }
        } catch {
            print("Error encoding or sending event: \(error)")
        }
    }
}

extension ArkMultiplayerManager: ArkMultiplayerECSDelegate {
    var isModificationEnabled: Bool {
        self.role == .host
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
        guard self.role == .host else {
            return
        }
        sendEcsFunction(function: "createEntity", entity: entity)
    }

    func didRemoveEntity(_ entity: Entity) {
        guard self.role == .host else {
            return
        }
        sendEcsFunction(function: "removeEntity", entity: entity)
    }

    func didUpsertComponent<T: Component>(_ component: T, to entity: Entity) {
        guard self.role == .host else {
            return
        }
        sendEcsFunction(function: "upsertComponent", entity: entity, component: component)
    }

    func didCreateEntity(_ entity: Entity, with components: [Component]) {
        guard self.role == .host else {
            return
        }
        sendEcsFunction(function: "createEntity", entity: entity, components: components)
    }

}
