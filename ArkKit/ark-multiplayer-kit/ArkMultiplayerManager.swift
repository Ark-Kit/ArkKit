import Foundation

enum ArkPeerRole {
    case host
    case participant
}

class ArkMultiplayerManager: ArkNetworkDelegate, ArkMultiplayerContext {
    private var networkService: ArkNetworkProtocol
    var multiplayerEventManager: ArkMultiplayerEventManager?
    var arkMultiplayerECSDelegate: ArkMultiplayerECSDelegate?
    var ecs: ArkECS
    private var peers = [String]()
    private var host: String?
    private(set) var role: ArkPeerRole
    var playerNumber: Int {
        peers.firstIndex(of: networkService.deviceID) ?? 0
    }

    init(serviceName: String, role: ArkPeerRole, ecs: ArkECS) {
        self.networkService = ArkNetworkService(serviceName: serviceName)
        self.ecs = ecs
        self.role = role
        self.networkService.delegate = self
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

            if wrappedData.type == .ecs {
                let ecsWrapper = try ArkECSDataSerializer.decodeArkECS(from: wrappedData.payload)
                ecs.upsertEntityManager(entities: ecsWrapper.entities, components: ecsWrapper.decodeComponents())
                self.arkMultiplayerECSDelegate?.ecsDidUpdate()
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
    }

    private func updateRoles() {
        let sortedPeers = (peers + [networkService.deviceID]).sorted()
        host = sortedPeers.first

        role = host == networkService.deviceID ? .host : .participant
        print("Updated role: \(role)")
    }

    var isModificationEnabled: Bool {
        self.role == .host
    }

    func sendECS() {
        if isModificationEnabled {
            do {
                let encodedECS = try ArkECSDataSerializer.encodeArkECS(ecs: ecs)
                networkService.sendData(data: encodedECS)
            } catch {
                print("Error encoding or sending ecs function: \(error)")
            }
        }
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
            if let encodedEvent = try ArkEventDataSerializer.encodeEvent(event),
               let target = host {
                networkService.sendData(encodedEvent, to: target)
            }
        } catch {
            print("Error encoding or sending event: \(error)")
        }
    }
}

protocol ArkMultiplayerECSDelegate: AnyObject {
    func ecsDidUpdate()
}
