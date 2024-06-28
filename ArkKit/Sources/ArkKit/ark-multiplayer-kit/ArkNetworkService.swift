import UIKit
import P2PShare

/**
 * Service class that is used by each device to send or listen to updates over the network.
 */
class ArkNetworkService: AbstractNetworkService {
    private let myPeerInfo = PeerInfo(["name": UIDevice.current.name])
    private var peers: [PeerInfo] = []
    private var session: MultipeerSession!

    var subscriber: ArkNetworkSubscriberDelegate?
    var publisher: ArkNetworkPublisherDelegate?

    private(set) var serviceName: String

    required init(serviceName: String = "Ark") {
        let config = MultipeerSessionConfig(myPeerInfo: myPeerInfo,
                                            bonjourService: "_ArkMultiplayer._tcp",
                                            presharedKey: "\(serviceName)12345",
                                            identity: "testing")
        self.session = MultipeerSession(config: config, queue: .main)
        self.serviceName = serviceName
        setUpHandlers()

        session.startSharing()
    }

    var deviceID: String {
        myPeerInfo.peerID
    }

    private func setUpHandlers() {
        self.session.peersChangeHandler = { [weak self] peers in
            guard let strongSelf = self else {
                return
            }

            strongSelf.peers = peers
            strongSelf.publisher?.onChangeInObservers(manager: strongSelf, connectedDevices: peers.map { $0.peerID })
            print("Peers changed: \(peers.map { $0.info["name"] ?? $0.peerID })")
        }

        self.session.newPeerHandler = { peer in
            print("New peer joined: \(peer.info["name"] ?? peer.peerID)")
        }

        self.session.messageReceivedHandler = { [weak self] _, data in
            self?.subscriber?.onListen(data)
        }
    }

    func sendData(data: Data) {
        if !self.peers.isEmpty {
            session.sendToAllPeers(data: data)
        }
    }

    func sendData(_ data: Data, to peerName: String) {
        guard let peerInfo = peers.first(where: { $0.info["name"] == peerName }) else {
            return
        }

        session.send(to: peerInfo.peerID, data: data)
    }

    func disconnect() {
        session.stopSharing()
    }
}
